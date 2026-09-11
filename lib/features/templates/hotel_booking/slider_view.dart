import 'package:flutter/material.dart';

class SliderView extends StatefulWidget {
  const SliderView({required this.onDistanceChanged, required this.distanceValue, super.key});

  final ValueChanged<double> onDistanceChanged;
  final double distanceValue;

  @override
  State<SliderView> createState() => _SliderViewState();
}

class _SliderViewState extends State<SliderView> {
  late double _distanceValue;

  @override
  void initState() {
    super.initState();
    _distanceValue = widget.distanceValue;
  }

  @override
  void didUpdateWidget(SliderView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.distanceValue != oldWidget.distanceValue) {
      _distanceValue = widget.distanceValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final position = _distanceValue.round().clamp(1, 99);

    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(flex: position, child: const SizedBox()),
            SizedBox(
              width: 170,
              child: Text('Less than ${(_distanceValue / 10).toStringAsFixed(1)} km', textAlign: TextAlign.center),
            ),
            Expanded(flex: 100 - position, child: const SizedBox()),
          ],
        ),
        SliderTheme(
          data: SliderThemeData(
            thumbShape: _CustomThumbShape(shadowColor: colors.shadow, surfaceColor: colors.surface),
          ),
          child: Slider(
            onChanged: (double value) {
              setState(() {
                _distanceValue = value;
              });
              widget.onDistanceChanged(_distanceValue);
            },
            max: 100,
            activeColor: colors.secondary,
            inactiveColor: colors.outlineVariant,
            divisions: 100,
            value: _distanceValue,
          ),
        ),
      ],
    );
  }
}

class _CustomThumbShape extends SliderComponentShape {
  const _CustomThumbShape({required this.shadowColor, required this.surfaceColor});

  final Color shadowColor;
  final Color surfaceColor;

  static const _thumbRadius = 3.0;

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
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required Size sizeWithOverflow,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double textScaleFactor,
    required double value,
  }) {
    final canvas = context.canvas;
    final colorTween = ColorTween(begin: sliderTheme.disabledThumbColor, end: sliderTheme.thumbColor);
    canvas.drawPath(
      Path()
        ..addOval(Rect.fromPoints(Offset(center.dx + 12, center.dy + 12), Offset(center.dx - 12, center.dy - 12)))
        ..fillType = PathFillType.evenOdd,
      Paint()
        ..color = shadowColor.withValues(alpha: 0.5)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, convertRadiusToSigma(8)),
    );

    final cPaint = Paint();
    cPaint.color = surfaceColor;
    cPaint.strokeWidth = 14 / 2;
    canvas.drawCircle(Offset(center.dx, center.dy), 12, cPaint);
    cPaint.color = colorTween.evaluate(enableAnimation) ?? surfaceColor;
    canvas.drawCircle(Offset(center.dx, center.dy), 10, cPaint);
  }

  double convertRadiusToSigma(double radius) {
    return radius * 0.57735 + 0.5;
  }
}
