import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Smooths uniform circular outlines on Android without changing their geometry
/// Other corner geometries keep the framework painter
final class SdfRoundedRectangleBorder extends RoundedRectangleBorder {
  const SdfRoundedRectangleBorder({required this.devicePixelRatio, super.side, super.borderRadius})
    : assert(devicePixelRatio > 0 && devicePixelRatio < double.infinity);

  final double devicePixelRatio;

  static late final ui.FragmentShader _shader;
  static Future<void>? _initialization;

  static Future<void> initialize() {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      return Future<void>.value();
    }

    return _initialization ??= _loadShader();
  }

  static Future<void> _loadShader() async {
    final program = await ui.FragmentProgram.fromAsset('shaders/rounded_border.frag');
    _shader = program.fragmentShader();
  }

  @override
  bool operator ==(Object other) =>
      other is SdfRoundedRectangleBorder &&
      side == other.side &&
      borderRadius == other.borderRadius &&
      devicePixelRatio == other.devicePixelRatio;

  @override
  int get hashCode => Object.hash(side, borderRadius, devicePixelRatio);

  @override
  SdfRoundedRectangleBorder copyWith({BorderSide? side, BorderRadiusGeometry? borderRadius}) =>
      SdfRoundedRectangleBorder(
        devicePixelRatio: devicePixelRatio,
        side: side ?? this.side,
        borderRadius: borderRadius ?? this.borderRadius,
      );

  @override
  ShapeBorder scale(double t) => SdfRoundedRectangleBorder(
    devicePixelRatio: devicePixelRatio,
    side: side.scale(t),
    borderRadius: borderRadius * t,
  );

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is RoundedRectangleBorder) {
      return SdfRoundedRectangleBorder(
        devicePixelRatio: devicePixelRatio,
        side: BorderSide.lerp(a.side, side, t),
        borderRadius: BorderRadiusGeometry.lerp(a.borderRadius, borderRadius, t)!,
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b is RoundedRectangleBorder) {
      return SdfRoundedRectangleBorder(
        devicePixelRatio: devicePixelRatio,
        side: BorderSide.lerp(side, b.side, t),
        borderRadius: BorderRadiusGeometry.lerp(borderRadius, b.borderRadius, t)!,
      );
    }
    return super.lerpTo(b, t);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android || side.width == 0) {
      super.paint(canvas, rect, textDirection: textDirection);

      return;
    }
    if (side.style == BorderStyle.none || rect.isEmpty) return;
    final outer = borderRadius.resolve(textDirection).toRRect(rect).inflate(side.strokeOutset).scaleRadii();
    final radii = [outer.tlRadius, outer.trRadius, outer.brRadius, outer.blRadius];
    if (radii.any((radius) => radius.x != radius.y || radius != radii.first)) {
      super.paint(canvas, rect, textDirection: textDirection);

      return;
    }
    final color = side.color;
    final values = [
      outer.center.dx,
      outer.center.dy,
      outer.width / 2,
      outer.height / 2,
      outer.tlRadiusX,
      side.width,
      1 / devicePixelRatio,
      color.r * color.a,
      color.g * color.a,
      color.b * color.a,
      color.a,
    ];
    for (var i = 0; i < values.length; i++) {
      _shader.setFloat(i, values[i]);
    }
    canvas.drawRect(
      outer.outerRect.inflate(2),
      Paint()
        ..isAntiAlias = false
        ..shader = _shader,
    );
  }
}
