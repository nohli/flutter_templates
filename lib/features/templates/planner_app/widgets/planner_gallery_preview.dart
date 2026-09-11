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
                Positioned(left: 62, right: 18, top: 108, child: _TimelinePreview(ink: ink)),
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

class _TimelinePreview extends StatelessWidget {
  const _TimelinePreview({required this.ink});

  final Color ink;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _TimelineEntry(time: '09:30', accent: PlannerAppTheme.peach, ink: ink, widthFactor: 0.92),
        const SizedBox(height: 8),
        _TimelineEntry(time: '11:00', accent: PlannerAppTheme.sky, ink: ink, widthFactor: 0.74),
        const SizedBox(height: 8),
        _TimelineEntry(time: '14:00', accent: PlannerAppTheme.lime, ink: ink, widthFactor: 0.84),
      ],
    );
  }
}

class _TimelineEntry extends StatelessWidget {
  const _TimelineEntry({required this.time, required this.accent, required this.ink, required this.widthFactor});

  final String time;
  final Color accent;
  final Color ink;
  final double widthFactor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 30,
          child: Text(
            time,
            style: TextStyle(color: ink, fontSize: 5, fontWeight: FontWeight.w800),
          ),
        ),
        Transform.rotate(angle: 0.785, child: Container(width: 7, height: 7, color: accent)),
        const SizedBox(width: 8),
        Expanded(
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: widthFactor,
            child: Container(
              height: 15,
              decoration: BoxDecoration(color: accent, borderRadius: const BorderRadius.all(Radius.circular(2))),
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Container(width: 34, height: 2, color: PlannerAppTheme.navy),
            ),
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
