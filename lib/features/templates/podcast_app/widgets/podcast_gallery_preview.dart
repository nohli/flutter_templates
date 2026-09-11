import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../podcast_app_theme.dart';

class PodcastGalleryPreview extends StatelessWidget {
  const PodcastGalleryPreview({this.brightness = Brightness.light, super.key});

  final Brightness brightness;

  @override
  Widget build(BuildContext context) {
    final dark = brightness == Brightness.dark;
    final background = dark ? const Color(0xFF0E0D12) : const Color(0xFFFFF6E7);
    final ink = dark ? const Color(0xFFFFF8EE) : PodcastAppTheme.ink;
    final accent = dark ? const Color(0xFFFF6F91) : PodcastAppTheme.primary;

    return Semantics(
      excludeSemantics: true,
      image: true,
      label: 'Wave graphic podcast player preview',
      child: FittedBox(
        fit: BoxFit.fill,
        child: SizedBox(
          width: 300,
          height: 200,
          child: ColoredBox(
            color: background,
            child: Stack(
              children: <Widget>[
                Positioned(
                  left: 15,
                  top: 13,
                  child: Text(
                    'WAVE / 072',
                    style: TextStyle(color: accent, fontSize: 6, fontWeight: FontWeight.w800, letterSpacing: 1.4),
                  ),
                ),
                Positioned(
                  left: 15,
                  top: 41,
                  width: 110,
                  child: Text(
                    'LISTEN\nCLOSER.',
                    style: TextStyle(
                      color: ink,
                      fontFamily: PodcastAppTheme.displayFontName,
                      fontSize: 24,
                      height: 0.88,
                      fontWeight: FontWeight.w400,
                      letterSpacing: -1,
                    ),
                  ),
                ),
                Positioned(left: 17, top: 109, right: 128, height: 34, child: _Waveform(color: accent)),
                Positioned(
                  left: 17,
                  bottom: 17,
                  child: Text(
                    'SMALL WONDERS  /  MIRA COLE',
                    style: TextStyle(color: ink.withValues(alpha: 0.62), fontSize: 5.2, letterSpacing: 0.7),
                  ),
                ),
                Positioned(
                  right: -19,
                  top: 17,
                  child: _VinylDisc(ink: ink, accent: accent),
                ),
                Positioned(
                  right: 20,
                  bottom: 15,
                  child: _PlayStamp(background: background, ink: ink, accent: accent),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Waveform extends StatelessWidget {
  const _Waveform({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    const heights = <double>[9, 19, 13, 29, 18, 11, 25, 16, 31, 12, 20, 8, 24];
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        for (final height in heights) ...<Widget>[
          Container(width: 3, height: height, color: color),
          const SizedBox(width: 3),
        ],
      ],
    );
  }
}

class _VinylDisc extends StatelessWidget {
  const _VinylDisc({required this.ink, required this.accent});

  final Color ink;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 154,
      child: CustomPaint(
        painter: _VinylPainter(ink: ink, accent: accent),
      ),
    );
  }
}

class _PlayStamp extends StatelessWidget {
  const _PlayStamp({required this.background, required this.ink, required this.accent});

  final Color background;
  final Color ink;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: accent,
        shape: BoxShape.circle,
        border: Border.all(color: ink, width: 1.2),
      ),
      child: Icon(Icons.play_arrow_rounded, color: background, size: 24),
    );
  }
}

class _VinylPainter extends CustomPainter {
  const _VinylPainter({required this.ink, required this.accent});

  final Color ink;
  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide / 2;
    canvas.drawCircle(center, radius, Paint()..color = ink);
    for (var ring = 0.18; ring < 0.95; ring += 0.1) {
      canvas.drawCircle(
        center,
        radius * ring,
        Paint()
          ..color = ring == 0.18 ? accent : Colors.black.withValues(alpha: 0.26)
          ..style = PaintingStyle.stroke
          ..strokeWidth = ring == 0.18 ? 8 : 1,
      );
    }
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * 0.72),
      -math.pi * 0.9,
      math.pi * 0.55,
      false,
      Paint()
        ..color = accent
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawCircle(center, 5, Paint()..color = accent);
  }

  @override
  bool shouldRepaint(covariant _VinylPainter oldDelegate) => oldDelegate.ink != ink || oldDelegate.accent != accent;
}
