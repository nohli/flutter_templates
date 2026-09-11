import 'package:flutter/material.dart';

import '../models/dating_profile.dart';

class DatingProfileArtwork extends StatelessWidget {
  const DatingProfileArtwork({required this.palette, super.key});

  final DatingProfilePalette palette;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _DatingPortraitPainter(palette.colors), child: const SizedBox.expand());
  }
}

extension on DatingProfilePalette {
  ({Color accent, Color backdrop, Color clothing, Color glow, Color shadow, Color skin}) get colors => switch (this) {
    DatingProfilePalette.sunset => (
      backdrop: const Color(0xFFDD527D),
      glow: const Color(0xFFFFC989),
      accent: const Color(0xFFFFF0D8),
      skin: const Color(0xFF8F4B3E),
      shadow: const Color(0xFF593047),
      clothing: const Color(0xFF281A45),
    ),
    DatingProfilePalette.violet => (
      backdrop: const Color(0xFF6C58D9),
      glow: const Color(0xFFE7A7FF),
      accent: const Color(0xFFBDF4E7),
      skin: const Color(0xFFC47D61),
      shadow: const Color(0xFF3D286B),
      clothing: const Color(0xFF17244B),
    ),
    DatingProfilePalette.lagoon => (
      backdrop: const Color(0xFF168A91),
      glow: const Color(0xFF8BE9D3),
      accent: const Color(0xFFFFE199),
      skin: const Color(0xFF7B4638),
      shadow: const Color(0xFF174D5B),
      clothing: const Color(0xFF0E293B),
    ),
    DatingProfilePalette.citrus => (
      backdrop: const Color(0xFFCB7A24),
      glow: const Color(0xFFFFDD65),
      accent: const Color(0xFFFFA8C4),
      skin: const Color(0xFFC57A5D),
      shadow: const Color(0xFF783D35),
      clothing: const Color(0xFF4B244A),
    ),
  };
}

class _DatingPortraitPainter extends CustomPainter {
  const _DatingPortraitPainter(this.colors);

  final ({Color accent, Color backdrop, Color clothing, Color glow, Color shadow, Color skin}) colors;

  @override
  void paint(Canvas canvas, Size size) {
    final background = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(
      background,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[colors.glow, colors.backdrop, colors.shadow],
          stops: const <double>[0, 0.54, 1],
        ).createShader(background),
    );

    canvas.drawCircle(
      Offset(size.width * 0.18, size.height * 0.2),
      size.shortestSide * 0.18,
      Paint()..color = colors.accent.withValues(alpha: 0.78),
    );
    canvas.drawCircle(
      Offset(size.width * 0.9, size.height * 0.44),
      size.shortestSide * 0.28,
      Paint()..color = colors.glow.withValues(alpha: 0.28),
    );

    final shoulders = Path()
      ..moveTo(size.width * 0.1, size.height)
      ..quadraticBezierTo(size.width * 0.18, size.height * 0.69, size.width * 0.5, size.height * 0.66)
      ..quadraticBezierTo(size.width * 0.84, size.height * 0.69, size.width * 0.94, size.height)
      ..close();
    canvas.drawPath(shoulders, Paint()..color = colors.clothing);

    final neck = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(size.width * 0.51, size.height * 0.64),
        width: size.width * 0.18,
        height: size.height * 0.22,
      ),
      Radius.circular(size.width * 0.08),
    );
    canvas.drawRRect(neck, Paint()..color = colors.skin);

    final face = Rect.fromCenter(
      center: Offset(size.width * 0.5, size.height * 0.43),
      width: size.width * 0.43,
      height: size.height * 0.48,
    );
    canvas.drawOval(face, Paint()..color = colors.skin);

    final hair = Path()
      ..moveTo(size.width * 0.28, size.height * 0.43)
      ..cubicTo(
        size.width * 0.25,
        size.height * 0.14,
        size.width * 0.72,
        size.height * 0.1,
        size.width * 0.72,
        size.height * 0.42,
      )
      ..cubicTo(
        size.width * 0.65,
        size.height * 0.29,
        size.width * 0.48,
        size.height * 0.33,
        size.width * 0.38,
        size.height * 0.24,
      )
      ..cubicTo(
        size.width * 0.36,
        size.height * 0.33,
        size.width * 0.31,
        size.height * 0.35,
        size.width * 0.28,
        size.height * 0.43,
      )
      ..close();
    canvas.drawPath(hair, Paint()..color = colors.shadow);

    final features = Paint()
      ..color = colors.shadow
      ..strokeCap = StrokeCap.round
      ..strokeWidth = size.width * 0.012;
    canvas.drawLine(
      Offset(size.width * 0.4, size.height * 0.46),
      Offset(size.width * 0.45, size.height * 0.46),
      features,
    );
    canvas.drawLine(
      Offset(size.width * 0.57, size.height * 0.46),
      Offset(size.width * 0.62, size.height * 0.46),
      features,
    );
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.width * 0.515, size.height * 0.55),
        width: size.width * 0.12,
        height: size.height * 0.06,
      ),
      0.15,
      2.75,
      false,
      features..style = PaintingStyle.stroke,
    );

    final highlight = Path()
      ..moveTo(0, size.height * 0.87)
      ..quadraticBezierTo(size.width * 0.28, size.height * 0.74, size.width * 0.42, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(highlight, Paint()..color = colors.accent.withValues(alpha: 0.42));
  }

  @override
  bool shouldRepaint(covariant _DatingPortraitPainter oldDelegate) => oldDelegate.colors != colors;
}
