import 'package:flutter/material.dart';

import '../models/dating_profile.dart';
import 'dating_profile_artwork.dart';

class DatingProfileCard extends StatelessWidget {
  const DatingProfileCard({required this.profile, super.key});

  final DatingProfile profile;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Semantics(
      container: true,
      label: '${profile.name}, ${profile.age}, ${profile.distance}',
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          border: Border.all(color: colors.outlineVariant),
          borderRadius: const BorderRadius.all(Radius.circular(32)),
          boxShadow: <BoxShadow>[
            BoxShadow(color: colors.shadow.withValues(alpha: 0.24), blurRadius: 32, offset: const Offset(0, 18)),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(31)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AspectRatio(
                aspectRatio: 1.08,
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(child: DatingProfileArtwork(palette: profile.palette)),
                    const Positioned(right: 18, top: 18, child: _MatchBadge()),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 20, 22, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Wrap(
                      spacing: 10,
                      runSpacing: 6,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: <Widget>[
                        Text(
                          '${profile.name}, ${profile.age}',
                          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -0.8),
                        ),
                        Icon(Icons.verified_rounded, color: colors.primary, size: 22),
                        Text(profile.distance, style: TextStyle(color: colors.onSurfaceVariant)),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Text(
                      profile.prompt.toUpperCase(),
                      style: TextStyle(
                        color: colors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      profile.answer,
                      style: const TextStyle(fontSize: 18, height: 1.38, fontWeight: FontWeight.w600),
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
        color: const Color(0xFF17111E).withValues(alpha: 0.76),
        border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
        borderRadius: const BorderRadius.all(Radius.circular(99)),
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
        borderRadius: const BorderRadius.all(Radius.circular(99)),
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
