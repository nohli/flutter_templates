import 'package:flutter/material.dart';

import '../dating_app_theme.dart';
import '../models/dating_profile.dart';
import 'dating_profile_artwork.dart';

class DatingProfileCard extends StatelessWidget {
  const DatingProfileCard({required this.profile, super.key});

  final DatingProfile profile;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final largeText = MediaQuery.textScalerOf(context).scale(1) >= 2;

    return Semantics(
      container: true,
      label: '${profile.name}, ${profile.age}, ${profile.distance}',
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          border: Border.all(color: colors.primary, width: 2),
          boxShadow: <BoxShadow>[BoxShadow(color: colors.primary.withValues(alpha: 0.6), offset: const Offset(7, 7))],
        ),
        child: ClipRect(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AspectRatio(
                aspectRatio: largeText ? 1.25 : 0.96,
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(child: DatingProfileArtwork(palette: profile.palette)),
                    const Positioned(right: 14, top: 14, child: _MatchBadge()),
                    if (!largeText)
                      Positioned(
                        left: 14,
                        right: 14,
                        bottom: 14,
                        child: DecoratedBox(
                          decoration: const BoxDecoration(color: Color(0xD917111E)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    '${profile.name}, ${profile.age}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: DatingAppTheme.displayFontName,
                                      fontSize: 31,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: -0.4,
                                    ),
                                  ),
                                ),
                                const Icon(Icons.verified_rounded, color: DatingAppTheme.mint, size: 21),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 17, 18, 21),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (largeText) ...<Widget>[
                      Text(
                        '${profile.name}, ${profile.age}',
                        style: const TextStyle(
                          fontFamily: DatingAppTheme.displayFontName,
                          fontSize: 28,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                    Text(
                      'PORTRAIT 01 / ${profile.distance.toUpperCase()}',
                      style: TextStyle(color: colors.onSurfaceVariant, fontSize: 8, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'ASK / ${profile.prompt.toUpperCase()}',
                      style: TextStyle(
                        color: colors.primary,
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      profile.answer,
                      style: const TextStyle(
                        fontFamily: DatingAppTheme.displayFontName,
                        fontSize: 22,
                        height: 1.15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: <Widget>[for (final interest in profile.interests) _InterestChip(label: interest)],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MatchBadge extends StatelessWidget {
  const _MatchBadge();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xE617111E),
        border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.auto_awesome_rounded, color: Color(0xFFFFD36B), size: 16),
            SizedBox(width: 6),
            Text(
              '98% match',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

class _InterestChip extends StatelessWidget {
  const _InterestChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.secondaryContainer,
        border: Border.all(color: colors.secondary),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          label,
          style: TextStyle(color: colors.onSecondaryContainer, fontSize: 13, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
