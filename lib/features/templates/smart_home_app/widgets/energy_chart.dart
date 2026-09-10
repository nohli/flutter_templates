import 'package:flutter/material.dart';

import '../smart_home_app_theme.dart';

class EnergyChart extends StatelessWidget {
  const EnergyChart({super.key});

  static const values = <double>[0.28, 0.44, 0.35, 0.66, 0.52, 0.8, 0.62];

  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: true,
      label: 'Seven-day energy use chart, highest on Saturday',
      child: const SizedBox(
        height: 150,
        width: double.infinity,
        child: CustomPaint(painter: _EnergyChartPainter(values)),
      ),
    );
  }
}

class _EnergyChartPainter extends CustomPainter {
  const _EnergyChartPainter(this.values);

  final List<double> values;

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = SmartHomeAppTheme.divider
      ..strokeWidth = 1;
    for (var row = 1; row < 4; row++) {
      final y = size.height * row / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final path = Path();
    for (var index = 0; index < values.length; index++) {
      final x = size.width * index / (values.length - 1);
      final y = size.height * (1 - values[index]);
      if (index == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    final linePaint = Paint()
      ..color = SmartHomeAppTheme.primary
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
    canvas.drawPath(path, linePaint);

    final dotPaint = Paint()..color = SmartHomeAppTheme.surface;
    final dotBorderPaint = Paint()
      ..color = SmartHomeAppTheme.primary
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    for (var index = 0; index < values.length; index++) {
      final point = Offset(size.width * index / (values.length - 1), size.height * (1 - values[index]));
      canvas
        ..drawCircle(point, 5, dotPaint)
        ..drawCircle(point, 5, dotBorderPaint);
    }
  }

  @override
  bool shouldRepaint(_EnergyChartPainter oldDelegate) => oldDelegate.values != values;
}
