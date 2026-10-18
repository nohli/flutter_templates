"""Render localized gallery artwork on a dedicated disposable iOS simulator.

Run with --device SIMULATOR_ID --output /private/tmp/TASK_ROOT/NEW_OUTPUT.
The native test target sends real widget PNGs to this loopback-only receiver.
The rendering target replaces the installed app without changing system language settings. Output stays temporary
until reviewed, losslessly optimized and copied into the app's asset catalog.
"""

import argparse
import hashlib
from http.server import BaseHTTPRequestHandler, HTTPServer
import json
import os
from pathlib import Path
import re
import signal
import struct
import subprocess
import threading
import time
import uuid


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--device', required=True)
    parser.add_argument('--output', type=Path, required=True)
    parser.add_argument('--locales', help='Comma-separated ARB identifiers; defaults to all')
    parser.add_argument('--appearances', default='light,dark')
    parser.add_argument('--timeout', type=int, default=1800)
    args = parser.parse_args()
    root = Path(__file__).resolve().parents[1]
    git_root = Path(subprocess.check_output(['git', 'rev-parse', '--show-toplevel'], cwd=root, text=True).strip()).resolve()
    if root != git_root:
        raise RuntimeError('Run from the owning source repository')
    output = args.output.resolve()
    if not output.is_relative_to(Path('/private/tmp')) or not output.parent.is_dir() or output.exists():
        raise ValueError('Choose a new output directory within your existing task-owned /private/tmp root')
    available = {json.loads(p.read_text())['@@locale'] for p in (root / 'lib/l10n').glob('app_*.arb')}
    locales = sorted(set(args.locales.split(',')) if args.locales else available)
    appearances = args.appearances.split(',')
    if not locales or not set(locales) <= available or not set(appearances) <= {'light', 'dark'}:
        raise ValueError('Choose existing locales and light/dark appearances')
    source = (root / 'lib/features/gallery/models/template_gallery_item.dart').read_text()
    assets = re.findall(r"TemplateGalleryDestination\.\w+ => '([^']+)'", source)
    if len(assets) != 10 or len(set(assets)) != 10:
        raise RuntimeError('Expected the ten gallery destination asset names')
    expected = {f'{locale}/{asset}{"-dark" if appearance == "dark" else ""}.png'
                for locale in locales for appearance in appearances for asset in assets}
    output.mkdir()
    received = {}
    token = uuid.uuid4().hex

    class Receiver(BaseHTTPRequestHandler):
        def log_message(self, *_):
            pass

        def do_POST(self):
            self.connection.settimeout(15)
            prefix = '/' + token + '/'
            name = self.path[len(prefix):] if self.path.startswith(prefix) else ''
            length = int(self.headers.get('Content-Length', '0'))
            if name not in expected or name in received or not 24 <= length <= 4_000_000:
                self.send_error(400)
                return
            data = self.rfile.read(length)
            if len(data) != length or data[:8] != b'\x89PNG\r\n\x1a\n' or struct.unpack('>II', data[16:24]) != (402, 874):
                self.send_error(400)
                return
            target = output / name
            if not target.resolve().is_relative_to(output):
                self.send_error(400)
                return
            target.parent.mkdir(exist_ok=True)
            temporary = target.with_suffix('.tmp')
            temporary.write_bytes(data)
            temporary.replace(target)
            received[name] = {'bytes': length, 'sha256': hashlib.sha256(data).hexdigest()}
            self.send_response(201)
            self.end_headers()
            self.wfile.write(b'ok')
            batch = len(assets) * len(appearances)
            if len(received) % batch == 0:
                print(json.dumps({'rendered': len(received), 'expected': len(expected), 'locale': name.split('/')[0]}), flush=True)

    server = HTTPServer(('127.0.0.1', 0), Receiver)
    thread = threading.Thread(target=server.serve_forever, daemon=True)
    thread.start()
    command = [
        'fvm', 'flutter', 'drive', '--no-pub', '--keep-app-running', '--device-id', args.device,
        '--driver', str(root / 'test_driver/integration_test.dart'),
        '--target', str(root / 'scripts/capture_gallery_previews.dart'),
        '--dart-define=GALLERY_PREVIEW_ENDPOINT=http://127.0.0.1:' + str(server.server_port) + '/' + token + '/',
        '--dart-define=GALLERY_PREVIEW_LOCALES=' + ','.join(locales),
        '--dart-define=GALLERY_PREVIEW_APPEARANCES=' + ','.join(appearances),
        '--timeout', str(args.timeout),
    ]
    started = time.monotonic()
    has_timed_out = False
    is_cleanup_verified = False
    process = None
    try:
        with (output / 'native-render.log').open('xb') as log:
            process = subprocess.Popen(command, cwd=root, stdout=log, stderr=subprocess.STDOUT, start_new_session=True)
            (output / 'process.json').write_text(json.dumps({'pid': process.pid, 'group': process.pid, 'device': args.device}) + '\n')
            try:
                exit_code = process.wait(timeout=args.timeout)
            except subprocess.TimeoutExpired:
                has_timed_out = True
                try:
                    os.killpg(process.pid, signal.SIGTERM)
                except ProcessLookupError:
                    pass
                try:
                    process.wait(timeout=5)
                except subprocess.TimeoutExpired:
                    try:
                        os.killpg(process.pid, signal.SIGKILL)
                    except ProcessLookupError:
                        pass
                    process.wait(timeout=5)
                exit_code = 124
            def has_group():
                groups = subprocess.check_output(['ps', '-axo', 'pgid='], text=True).splitlines()
                return str(process.pid) in {group.strip() for group in groups}

            if has_group():
                # Retaining the iOS app can leave Flutter's host log reader attached
                # This isolated group belongs to this invocation, not the simulator app
                try:
                    os.killpg(process.pid, signal.SIGTERM)
                except ProcessLookupError:
                    pass
                cleanup_deadline = time.monotonic() + 5
                while has_group() and time.monotonic() < cleanup_deadline:
                    time.sleep(0.1)
                if has_group():
                    try:
                        os.killpg(process.pid, signal.SIGKILL)
                    except ProcessLookupError:
                        pass
                    cleanup_deadline = time.monotonic() + 5
                    while has_group() and time.monotonic() < cleanup_deadline:
                        time.sleep(0.1)
            is_cleanup_verified = not has_group()
    finally:
        server.shutdown()
        server.server_close()
        thread.join(timeout=5)
    result = {
        'exit_code': exit_code, 'has_timed_out': has_timed_out, 'is_cleanup_verified': is_cleanup_verified,
        'device': args.device, 'locales': locales, 'appearances': appearances,
        'expected': len(expected), 'rendered': len(received), 'files': received,
        'seconds': round(time.monotonic() - started, 2),
    }
    result['is_ok'] = exit_code == 0 and is_cleanup_verified and set(received) == expected
    (output / 'manifest.json').write_text(json.dumps(result, indent=2) + '\n')
    print(json.dumps({key: value for key, value in result.items() if key != 'files'}), flush=True)
    if not result['is_ok']:
        raise SystemExit(1)


if __name__ == '__main__':
    main()
