import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/podcast_show.dart';
import '../podcast_app_theme.dart';

class PodcastVinyl extends StatelessWidget {
  const PodcastVinyl({required this.show, this.compact = false, super.key});

  final PodcastShow show;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: true,
      label: '${show.title} vinyl record',
      child: CustomPaint(
        painter: _VinylPainter(labelColor: _labelColor(show.tone), compact: compact),
      ),
    );
  }

  Color _labelColor(PodcastTone tone) => switch (tone) {
    PodcastTone.coral => PodcastAppTheme.primary,
    PodcastTone.cobalt => PodcastAppTheme.cobalt,
    PodcastTone.sky => PodcastAppTheme.sky,
    PodcastTone.sage => PodcastAppTheme.sage,
  };
}

class _VinylPainter extends CustomPainter {
  const _VinylPainter({required this.labelColor, required this.compact});

  final Color labelColor;
  final bool compact;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = math.min(size.width, size.height) / 2;
    final record = Paint()..color = const Color(0xFF11100D);
    canvas.drawCircle(center, radius, record);

    final groove = Paint()
      ..color = const Color(0xFF4C4940)
      ..style = PaintingStyle.stroke
      ..strokeWidth = compact ? 0.7 : 1;
    for (var factor = 0.34; factor < 0.94; factor += 0.095) {
      canvas.drawCircle(center, radius * factor, groove);
    }

    canvas.drawCircle(center, radius * 0.28, Paint()..color = labelColor);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * 0.19),
      -0.3,
      1.45,
      false,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.65)
        ..style = PaintingStyle.stroke
        ..strokeWidth = compact ? 2 : 4,
    );
    canvas.drawCircle(center, radius * 0.035, Paint()..color = PodcastAppTheme.signal);
  }

  @override
  bool shouldRepaint(covariant _VinylPainter oldDelegate) {
    return labelColor != oldDelegate.labelColor || compact != oldDelegate.compact;
  }
}
