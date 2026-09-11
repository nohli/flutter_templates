import 'package:flutter/material.dart';

import '../models/social_post.dart';
import '../social_app_theme.dart';

class SocialPostArt extends StatelessWidget {
  const SocialPostArt({required this.artwork, this.compact = false, super.key});

  final SocialPostArtwork artwork;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final palette = _paletteFor(artwork);
    final iconSize = compact ? 30.0 : 62.0;

    return Semantics(
      image: true,
      label: _labelFor(artwork),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: palette.gradient),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              right: compact ? -18 : -38,
              top: compact ? -16 : -32,
              child: CircleAvatar(radius: compact ? 34 : 70, backgroundColor: Colors.white.withValues(alpha: 0.18)),
            ),
            Positioned(
              left: compact ? -14 : -26,
              bottom: compact ? -20 : -42,
              child: CircleAvatar(radius: compact ? 38 : 74, backgroundColor: palette.orb.withValues(alpha: 0.42)),
            ),
            Icon(_iconFor(artwork), size: iconSize, color: Colors.white.withValues(alpha: 0.92)),
          ],
        ),
      ),
    );
  }

  ({List<Color> gradient, Color orb}) _paletteFor(SocialPostArtwork artwork) => switch (artwork) {
    SocialPostArtwork.sunset => (
      gradient: const <Color>[Color(0xFFFFA38F), Color(0xFF7D67D9)],
      orb: SocialAppTheme.amber,
    ),
    SocialPostArtwork.coast => (
      gradient: const <Color>[Color(0xFF4EB8C4), Color(0xFF355EB8)],
      orb: SocialAppTheme.mint,
    ),
    SocialPostArtwork.studio => (
      gradient: const <Color>[Color(0xFFFFBE73), Color(0xFFE2677C)],
      orb: SocialAppTheme.coral,
    ),
  };

  IconData _iconFor(SocialPostArtwork artwork) => switch (artwork) {
    SocialPostArtwork.sunset => Icons.wb_twilight_rounded,
    SocialPostArtwork.coast => Icons.waves_rounded,
    SocialPostArtwork.studio => Icons.palette_outlined,
  };

  String _labelFor(SocialPostArtwork artwork) => switch (artwork) {
    SocialPostArtwork.sunset => 'Abstract sunset illustration',
    SocialPostArtwork.coast => 'Abstract coastal illustration',
    SocialPostArtwork.studio => 'Abstract studio palette illustration',
  };
}
