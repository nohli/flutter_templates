import 'package:flutter/material.dart';

import '../models/social_post.dart';
import '../social_app_theme.dart';

class SocialPostArt extends StatelessWidget {
  const SocialPostArt({required this.artwork, this.compact = false, super.key});

  final SocialPostArtwork artwork;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: true,
      label: _labelFor(artwork),
      child: CustomPaint(
        painter: _SocialCollagePainter(artwork: artwork, compact: compact),
      ),
    );
  }

  String _labelFor(SocialPostArtwork artwork) => switch (artwork) {
    SocialPostArtwork.sunset => 'Abstract sunset illustration',
    SocialPostArtwork.coast => 'Abstract coastal illustration',
    SocialPostArtwork.studio => 'Abstract studio palette illustration',
  };
}

class _SocialCollagePainter extends CustomPainter {
  const _SocialCollagePainter({required this.artwork, required this.compact});

  final SocialPostArtwork artwork;
  final bool compact;

  @override
  void paint(Canvas canvas, Size size) {
    switch (artwork) {
      case SocialPostArtwork.sunset:
        _paintSunset(canvas, size);
      case SocialPostArtwork.coast:
        _paintCoast(canvas, size);
      case SocialPostArtwork.studio:
        _paintStudio(canvas, size);
    }

    final grain = Paint()..color = SocialAppTheme.ink.withValues(alpha: 0.12);
    final step = compact ? 14.0 : 22.0;
    for (var x = step / 2; x < size.width; x += step) {
      for (var y = step / 2; y < size.height; y += step) {
        canvas.drawCircle(Offset(x, y), compact ? 0.6 : 1, grain);
      }
    }
  }

  void _paintSunset(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = SocialAppTheme.coral);
    canvas.drawCircle(
      Offset(size.width * 0.7, size.height * 0.38),
      size.shortestSide * 0.24,
      Paint()..color = SocialAppTheme.amber,
    );
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.67, size.width, size.height * 0.33),
      Paint()..color = SocialAppTheme.primary,
    );
    final line = Paint()
      ..color = SocialAppTheme.ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = compact ? 2 : 5;
    final path = Path()
      ..moveTo(0, size.height * 0.72)
      ..quadraticBezierTo(size.width * 0.24, size.height * 0.56, size.width * 0.48, size.height * 0.74)
      ..quadraticBezierTo(size.width * 0.72, size.height * 0.9, size.width, size.height * 0.68);
    canvas.drawPath(path, line);
  }

  void _paintCoast(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = SocialAppTheme.primary);
    final cliff = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width * 0.48, 0)
      ..lineTo(size.width * 0.35, size.height * 0.32)
      ..lineTo(size.width * 0.51, size.height * 0.58)
      ..lineTo(size.width * 0.25, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(cliff, Paint()..color = SocialAppTheme.mint);
    canvas.drawCircle(
      Offset(size.width * 0.78, size.height * 0.24),
      size.shortestSide * 0.12,
      Paint()..color = SocialAppTheme.coral,
    );
    final wave = Paint()
      ..color = const Color(0xFFFFFBED)
      ..style = PaintingStyle.stroke
      ..strokeWidth = compact ? 2 : 5;
    for (var y = 0.62; y < 0.96; y += 0.12) {
      canvas.drawArc(
        Rect.fromLTWH(size.width * 0.42, size.height * y, size.width * 0.7, size.height * 0.22),
        3.45,
        2.4,
        false,
        wave,
      );
    }
  }

  void _paintStudio(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = SocialAppTheme.amber);
    canvas.save();
    canvas.translate(size.width * 0.18, size.height * 0.08);
    canvas.rotate(-0.08);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width * 0.68, size.height * 0.82),
      Paint()..color = const Color(0xFFFFFBED),
    );
    canvas.drawCircle(
      Offset(size.width * 0.22, size.height * 0.28),
      size.shortestSide * 0.15,
      Paint()..color = SocialAppTheme.primary,
    );
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.38, size.height * 0.12, size.width * 0.12, size.height * 0.56),
      Paint()..color = SocialAppTheme.coral,
    );
    canvas.restore();
    canvas.drawLine(
      Offset(size.width * 0.12, size.height * 0.88),
      Offset(size.width * 0.9, size.height * 0.45),
      Paint()
        ..color = SocialAppTheme.ink
        ..strokeWidth = compact ? 4 : 10
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _SocialCollagePainter oldDelegate) {
    return artwork != oldDelegate.artwork || compact != oldDelegate.compact;
  }
}
