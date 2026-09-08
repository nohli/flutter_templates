import 'package:flutter/material.dart';

class RangeSliderView extends StatefulWidget {
  const RangeSliderView({required this.values, required this.onChangeRangeValues, super.key});

  final ValueChanged<RangeValues> onChangeRangeValues;
  final RangeValues values;

  @override
  State<RangeSliderView> createState() => _RangeSliderViewState();
}

class _RangeSliderViewState extends State<RangeSliderView> {
  late RangeValues _values;
  @override
  void initState() {
    super.initState();
    _values = widget.values;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final startPosition = _values.start.round().clamp(1, 999);
    final endPosition = _values.end.round().clamp(1, 999);

    return Column(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(flex: startPosition, child: const SizedBox()),
                SizedBox(width: 54, child: Text('\$${_values.start.round()}', textAlign: TextAlign.center)),
                Expanded(flex: 1000 - startPosition, child: const SizedBox()),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(flex: endPosition, child: const SizedBox()),
                SizedBox(width: 54, child: Text('\$${_values.end.round()}', textAlign: TextAlign.center)),
                Expanded(flex: 1000 - endPosition, child: const SizedBox()),
              ],
            ),
          ],
        ),
        SliderTheme(
          data: SliderThemeData(
            rangeThumbShape: _CustomRangeThumbShape(
              shadowColor: colors.shadow,
              surfaceColor: colors.surface,
              foregroundColor: colors.onPrimary,
            ),
          ),
          child: RangeSlider(
            values: _values,
            max: 1000.0,
            activeColor: colors.secondary,
            inactiveColor: colors.outlineVariant,
            divisions: 1000,
            onChanged: (RangeValues values) {
              setState(() {
                _values = values;
              });
              widget.onChangeRangeValues(_values);
            },
          ),
        ),
      ],
    );
  }
}

class _CustomRangeThumbShape extends RangeSliderThumbShape {
  const _CustomRangeThumbShape({required this.shadowColor, required this.surfaceColor, required this.foregroundColor});

  final Color foregroundColor;
  final Color shadowColor;
  final Color surfaceColor;

  static const double _thumbRadius = 3.0;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size.fromRadius(_thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required SliderThemeData sliderTheme,
    bool isDiscrete = false,
    bool isEnabled = false,
    bool isOnTop = false,
    bool isPressed = false,
    TextDirection textDirection = TextDirection.ltr,
    Thumb thumb = Thumb.start,
  }) {
    final Canvas canvas = context.canvas;
    final ColorTween colorTween = ColorTween(begin: sliderTheme.disabledThumbColor, end: sliderTheme.thumbColor);

    Path thumbPath;
    switch (textDirection) {
      case TextDirection.rtl:
        switch (thumb) {
          case Thumb.start:
            thumbPath = _rightTriangle(center);
            break;
          case Thumb.end:
            thumbPath = _leftTriangle(center);
            break;
        }
        break;
      case TextDirection.ltr:
        switch (thumb) {
          case Thumb.start:
            thumbPath = _leftTriangle(center);
            break;
          case Thumb.end:
            thumbPath = _rightTriangle(center);
            break;
        }
        break;
    }

    canvas.drawPath(
      Path()
        ..addOval(Rect.fromPoints(Offset(center.dx + 12, center.dy + 12), Offset(center.dx - 12, center.dy - 12)))
        ..fillType = PathFillType.evenOdd,
      Paint()
        ..color = shadowColor.withValues(alpha: 0.5)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, convertRadiusToSigma(8)),
    );

    final Paint cPaint = Paint();
    cPaint.color = surfaceColor;
    cPaint.strokeWidth = 14 / 2;
    canvas.drawCircle(Offset(center.dx, center.dy), 12, cPaint);
    cPaint.color = colorTween.evaluate(enableAnimation) ?? surfaceColor;
    canvas.drawCircle(Offset(center.dx, center.dy), 10, cPaint);
    canvas.drawPath(thumbPath, Paint()..color = foregroundColor);
  }

  double convertRadiusToSigma(double radius) {
    return radius * 0.57735 + 0.5;
  }

  Path _rightTriangle(Offset thumbCenter, {bool invert = false}) {
    final Path thumbPath = Path();
    final double sign = invert ? -1.0 : 1.0;
    thumbPath.moveTo(thumbCenter.dx + 5 * sign, thumbCenter.dy);
    thumbPath.lineTo(thumbCenter.dx - 3 * sign, thumbCenter.dy - 5);
    thumbPath.lineTo(thumbCenter.dx - 3 * sign, thumbCenter.dy + 5);
    thumbPath.close();
    return thumbPath;
  }

  Path _leftTriangle(Offset thumbCenter) => _rightTriangle(thumbCenter, invert: true);
}
