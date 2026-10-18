import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart' show debugDefaultTargetPlatformOverride;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:templates/app/sdf_rounded_rectangle_border.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(SdfRoundedRectangleBorder.initialize);

  test('repeated preparation reuses the compiled shader', () async {
    final first = SdfRoundedRectangleBorder.initialize();
    final second = SdfRoundedRectangleBorder.initialize();
    expect(identical(first, second), isTrue);
    await Future.wait([first, second]);
  });

  test('multiple borders retain their own color and bounds in one frame', () async {
    final image = await _raster(
      SdfRoundedRectangleBorder(
        devicePixelRatio: 2,
        side: const BorderSide(color: Colors.blue),
        borderRadius: BorderRadius.circular(16),
      ),
      overlay: SdfRoundedRectangleBorder(
        devicePixelRatio: 2,
        side: const BorderSide(color: Colors.red, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
    );
    final blue = (21 * image.width + 100) * 4;
    final red = (52 * image.width + 100) * 4;
    expect(image.pixels[blue], lessThan(image.pixels[blue + 2]));
    expect(image.pixels[red], greaterThan(image.pixels[red + 2] + 100));
  });

  test('unequal oversized corners retain the native inner contour', () async {
    const radii = BorderRadius.only(
      topLeft: Radius.circular(40),
      topRight: Radius.circular(8),
      bottomRight: Radius.circular(8),
      bottomLeft: Radius.circular(40),
    );
    const stock = RoundedRectangleBorder(
      side: BorderSide(color: Colors.black),
      borderRadius: radii,
    );
    final shape = SdfRoundedRectangleBorder(devicePixelRatio: 2.625, side: stock.side, borderRadius: radii);
    final expected = await _raster(stock, density: 2.625);
    final actual = await _raster(shape, density: 2.625);
    final index = (32 * actual.width + 230) * 4;
    expect((actual.pixels[index] - expected.pixels[index]).abs(), lessThanOrEqualTo(12));
  });

  test('a display density change updates the border', () {
    const first = SdfRoundedRectangleBorder(devicePixelRatio: 2);
    const second = SdfRoundedRectangleBorder(devicePixelRatio: 3);
    expect(first, isNot(second));
  });

  test('equal borders keep equal hashes and copies retain their density', () {
    const shape = SdfRoundedRectangleBorder(
      devicePixelRatio: 2.625,
      side: BorderSide(width: 2),
      borderRadius: BorderRadius.all(Radius.circular(16)),
    );
    final copy = shape.copyWith();
    expect(copy, shape);
    expect(copy.hashCode, shape.hashCode);
    final changed = shape.copyWith(side: const BorderSide(width: 1), borderRadius: BorderRadius.circular(20));
    expect(changed.devicePixelRatio, shape.devicePixelRatio);
    expect(changed, isNot(shape));
    expect(shape.copyWith(side: const BorderSide(width: 1)), isNot(shape));
    expect(shape.copyWith(borderRadius: BorderRadius.circular(20)), isNot(shape));
    final scaled = shape.scale(0.5) as SdfRoundedRectangleBorder;
    expect(scaled.devicePixelRatio, shape.devicePixelRatio);
    expect(scaled.side.width, 1);
    expect(scaled.borderRadius, BorderRadius.circular(8));
    expect(shape, isNot(const RoundedRectangleBorder()));
  });

  test('material interpolation and layout keep the stock border geometry', () {
    const shape = SdfRoundedRectangleBorder(
      devicePixelRatio: 3,
      side: BorderSide(width: 2),
      borderRadius: BorderRadiusDirectional.only(topStart: Radius.circular(20), bottomEnd: Radius.circular(12)),
    );
    final stock = RoundedRectangleBorder(side: shape.side, borderRadius: shape.borderRadius);
    for (final direction in TextDirection.values) {
      expect(
        shape.getOuterPath(_rect, textDirection: direction).getBounds(),
        stock.getOuterPath(_rect, textDirection: direction).getBounds(),
      );
      expect(
        shape.getInnerPath(_rect, textDirection: direction).getBounds(),
        stock.getInnerPath(_rect, textDirection: direction).getBounds(),
      );
    }
    expect(shape.dimensions, stock.dimensions);
    final start = shape.lerpFrom(const RoundedRectangleBorder(), 0.5)! as SdfRoundedRectangleBorder;
    final end = shape.lerpTo(const RoundedRectangleBorder(), 0.5)! as SdfRoundedRectangleBorder;
    expect(start.devicePixelRatio, 3);
    expect(end.devicePixelRatio, 3);
    expect(start.side.width, 1);
    expect(end.side.width, 1);
    expect(shape.lerpFrom(null, 0.5), isA<SdfRoundedRectangleBorder>());
    expect(shape.lerpTo(null, 0.5), isA<SdfRoundedRectangleBorder>());
    for (final other in <ShapeBorder>[const CircleBorder(), const StadiumBorder()]) {
      expect(shape.lerpFrom(other, 0.5).runtimeType, stock.lerpFrom(other, 0.5).runtimeType);
      expect(shape.lerpTo(other, 0.5).runtimeType, stock.lerpTo(other, 0.5).runtimeType);
    }
  });

  test('invalid display densities are rejected', () {
    for (final density in [0.0, -1.0, double.infinity, double.nan]) {
      expect(() => SdfRoundedRectangleBorder(devicePixelRatio: density), throwsAssertionError);
    }
  });

  for (final brightness in Brightness.values) {
    for (final density in [1.0, 2.0, 2.625, 3.0]) {
      for (final isEnabled in [true, false]) {
        test('rounded outline stays continuous in ${brightness.name}, ${density}x, enabled $isEnabled', () async {
          final theme = ThemeData(brightness: brightness);
          final background = theme.colorScheme.surface;
          final color = theme.colorScheme.outline.withValues(alpha: isEnabled ? 1 : 0.3);
          final image = await _raster(
            SdfRoundedRectangleBorder(
              devicePixelRatio: density,
              side: BorderSide(color: color),
              borderRadius: BorderRadius.circular(16),
            ),
            density: density,
            background: background,
          );
          final fill = background.r * 255;
          final direction = color.r > background.r ? 1 : -1;
          final radius = 15.5 * density;
          final corners = [
            (Offset(_rect.left + 16, _rect.top + 16) * density, math.pi),
            (Offset(_rect.right - 16, _rect.top + 16) * density, 1.5 * math.pi),
            (Offset(_rect.right - 16, _rect.bottom - 16) * density, 0.0),
            (Offset(_rect.left + 16, _rect.bottom - 16) * density, 0.5 * math.pi),
          ];
          for (final (center, start) in corners) {
            for (var degrees = 0; degrees <= 90; degrees += 15) {
              final angle = start + degrees * math.pi / 180;
              final point = center + Offset(math.cos(angle), math.sin(angle)) * radius;
              var strongest = 0.0;
              for (var y = point.dy.floor() - 1; y <= point.dy.ceil() + 1; y++) {
                for (var x = point.dx.floor() - 1; x <= point.dx.ceil() + 1; x++) {
                  strongest = math.max(strongest, (image.pixels[(y * image.width + x) * 4] - fill) * direction);
                }
              }
              final minimum = math.min(0.2 * density, 0.75) * (color.r - background.r).abs() * 255 * color.a;
              expect(
                strongest,
                greaterThanOrEqualTo(minimum),
                reason: 'Faint outline at $degrees degrees in corner $center',
              );
            }
          }
        });
      }
    }
  }

  test('hairlines, elliptical corners and hidden borders preserve stock painting', () async {
    for (final stock in [
      const RoundedRectangleBorder(side: BorderSide(width: 0)),
      RoundedRectangleBorder(
        side: const BorderSide(),
        borderRadius: BorderRadius.circular(16).copyWith(topLeft: const Radius.elliptical(20, 12)),
      ),
      const RoundedRectangleBorder(side: BorderSide(width: 2, style: BorderStyle.none)),
    ]) {
      final shape = SdfRoundedRectangleBorder(devicePixelRatio: 2, side: stock.side, borderRadius: stock.borderRadius);
      expect((await _raster(shape)).pixels, (await _raster(stock)).pixels);
    }
    const shape = SdfRoundedRectangleBorder(devicePixelRatio: 2, side: BorderSide());
    expect((await _raster(shape, rect: Rect.zero)).pixels, (await _raster(const RoundedRectangleBorder())).pixels);
  });

  test('a stroke wider than the box fills the outer shape', () async {
    final stock = RoundedRectangleBorder(side: const BorderSide(width: 40), borderRadius: BorderRadius.circular(16));
    final shape = SdfRoundedRectangleBorder(devicePixelRatio: 2, side: stock.side, borderRadius: stock.borderRadius);
    final expected = await _raster(stock);
    final actual = await _raster(shape);
    final index = (72 * actual.width + 100) * 4;
    expect(expected.pixels[index], 0);
    expect(actual.pixels[index], expected.pixels[index]);
  });

  test('iOS keeps the native painter and initialization path', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    try {
      await SdfRoundedRectangleBorder.initialize();
      final shape = SdfRoundedRectangleBorder(
        devicePixelRatio: 3,
        side: const BorderSide(),
        borderRadius: BorderRadius.circular(16),
      );
      final stock = RoundedRectangleBorder(side: shape.side, borderRadius: shape.borderRadius);
      expect((await _raster(shape)).pixels, (await _raster(stock)).pixels);
    } finally {
      debugDefaultTargetPlatformOverride = null;
    }
  });
}

const _rect = Rect.fromLTWH(10.25, 10.25, 80, 52);

Future<({Uint8List pixels, int width})> _raster(
  OutlinedBorder shape, {
  double density = 2,
  Color background = Colors.white,
  Rect rect = _rect,
  OutlinedBorder? overlay,
}) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder)..scale(density);
  canvas.drawColor(background, BlendMode.src);
  shape.paint(canvas, rect, textDirection: TextDirection.ltr);
  overlay?.paint(canvas, const Rect.fromLTWH(30, 25, 40, 25), textDirection: TextDirection.ltr);
  final picture = recorder.endRecording();
  try {
    final image = await picture.toImage((100 * density).ceil(), (80 * density).ceil());
    try {
      final data = (await image.toByteData(format: ui.ImageByteFormat.rawRgba))!;

      return (pixels: data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes), width: image.width);
    } finally {
      image.dispose();
    }
  } finally {
    picture.dispose();
  }
}
