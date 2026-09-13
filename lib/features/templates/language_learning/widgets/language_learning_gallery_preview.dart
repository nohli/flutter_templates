import 'package:flutter/material.dart';

import '../language_learning_theme.dart';

class LanguageLearningGalleryPreview extends StatelessWidget {
  const LanguageLearningGalleryPreview({required this.brightness, super.key});

  final Brightness brightness;

  @override
  Widget build(BuildContext context) {
    final dark = brightness == Brightness.dark;
    final background = dark ? LanguageLearningTheme.darkBackground : LanguageLearningTheme.lightBackground;
    final surface = dark ? LanguageLearningTheme.darkSurface : Colors.white;
    final ink = dark ? const Color(0xFFF4FAF5) : const Color(0xFF173126);
    return Semantics(
      image: true,
      label: 'Lingo Trail lesson path preview',
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
                  left: 17,
                  top: 17,
                  child: Text(
                    'LINGO TRAIL',
                    style: TextStyle(
                      color: ink,
                      fontFamily: LanguageLearningTheme.displayFontName,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const Positioned(
                  right: 18,
                  top: 16,
                  child: Text('🔥 12  💎 860', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800)),
                ),
                Positioned(
                  left: 16,
                  right: 16,
                  top: 46,
                  child: Container(
                    height: 45,
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: LanguageLearningTheme.primary,
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    child: const Text(
                      'UNIT 4\nOrder food with confidence',
                      style: TextStyle(color: Colors.white, fontSize: 7, fontWeight: FontWeight.w800, height: 1.3),
                    ),
                  ),
                ),
                Positioned.fill(
                  top: 97,
                  child: CustomPaint(
                    painter: _PreviewPathPainter(surface: surface, ink: ink),
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

class _PreviewPathPainter extends CustomPainter {
  const _PreviewPathPainter({required this.surface, required this.ink});

  final Color surface;
  final Color ink;

  @override
  void paint(Canvas canvas, Size size) {
    final connector = Paint()
      ..color = ink.withValues(alpha: 0.15)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    final path = Path()
      ..moveTo(size.width * 0.35, 10)
      ..cubicTo(size.width * 0.75, 28, size.width * 0.68, 52, size.width * 0.48, 64)
      ..cubicTo(size.width * 0.2, 80, size.width * 0.3, 97, size.width * 0.58, 108);
    canvas.drawPath(path, connector);
    const points = <Offset>[Offset(105, 10), Offset(187, 43), Offset(145, 72), Offset(174, 103)];
    for (var index = 0; index < points.length; index++) {
      canvas.drawCircle(
        points[index],
        index < 2 ? 14 : 12,
        Paint()..color = index < 2 ? LanguageLearningTheme.primary : surface,
      );
      canvas.drawCircle(
        points[index],
        index < 2 ? 9 : 7,
        Paint()..color = index < 2 ? Colors.white : ink.withValues(alpha: 0.22),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _PreviewPathPainter oldDelegate) =>
      oldDelegate.surface != surface || oldDelegate.ink != ink;
}
