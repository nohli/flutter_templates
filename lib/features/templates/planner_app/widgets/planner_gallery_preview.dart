import 'package:flutter/material.dart';

import '../planner_app_theme.dart';

class PlannerGalleryPreview extends StatelessWidget {
  const PlannerGalleryPreview({this.brightness = Brightness.light, super.key});

  final Brightness brightness;

  @override
  Widget build(BuildContext context) {
    final dark = brightness == Brightness.dark;
    final background = dark ? const Color(0xFF101522) : const Color(0xFFF3F0E8);
    final ink = dark ? const Color(0xFFF1F3FA) : PlannerAppTheme.ink;

    return Semantics(
      excludeSemantics: true,
      image: true,
      label: 'Daymark graphic daily planner preview',
      child: FittedBox(
        fit: BoxFit.fill,
        child: SizedBox(
          width: 300,
          height: 200,
          child: ColoredBox(
            color: background,
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: CustomPaint(painter: _PlannerGridPainter(color: ink)),
                ),
                const Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  width: 42,
                  child: ColoredBox(color: PlannerAppTheme.primary),
                ),
                Positioned(
                  left: 13,
                  top: 14,
                  child: RotatedBox(
                    quarterTurns: 1,
                    child: Text(
                      'DAYMARK  /  THURSDAY',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 6, letterSpacing: 1.4),
                    ),
                  ),
                ),
                Positioned(
                  left: 60,
                  top: 19,
                  child: Text(
                    '11',
                    style: TextStyle(
                      color: ink,
                      fontFamily: PlannerAppTheme.displayFontName,
                      fontSize: 67,
                      height: 0.82,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -5,
                    ),
                  ),
                ),
                Positioned(left: 65, top: 83, child: Container(width: 92, height: 9, color: PlannerAppTheme.lime)),
                Positioned(
                  right: 17,
                  top: 20,
                  child: Text(
                    'SEP\n2026',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: ink,
                      fontFamily: PlannerAppTheme.fontName,
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                      height: 1.05,
                    ),
                  ),
                ),
                Positioned(left: 62, right: 18, top: 112, child: _PlanStrip(ink: ink)),
                Positioned(
                  left: 62,
                  right: 18,
                  top: 143,
                  child: _PlanStrip(ink: ink, accent: PlannerAppTheme.peach),
                ),
                Positioned(
                  right: 18,
                  bottom: 14,
                  child: Text(
                    '03 / 05 COMPLETE',
                    style: TextStyle(color: ink.withValues(alpha: 0.55), fontSize: 5, letterSpacing: 1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PlanStrip extends StatelessWidget {
  const _PlanStrip({required this.ink, this.accent = PlannerAppTheme.sky});

  final Color ink;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 20,
          height: 20,
          color: accent,
          alignment: Alignment.center,
          child: Icon(Icons.check, size: 10, color: ink),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(height: 3, color: ink),
              const SizedBox(height: 5),
              FractionallySizedBox(widthFactor: 0.56, child: Container(height: 2, color: ink.withValues(alpha: 0.3))),
            ],
          ),
        ),
      ],
    );
  }
}

class _PlannerGridPainter extends CustomPainter {
  const _PlannerGridPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.08)
      ..strokeWidth = 0.7;
    for (var x = 42.0; x < size.width; x += 28) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (var y = 0.0; y < size.height; y += 28) {
      canvas.drawLine(Offset(42, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _PlannerGridPainter oldDelegate) => oldDelegate.color != color;
}
