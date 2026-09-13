import 'package:flutter/material.dart';

import '../social_feed_theme.dart';

class SocialFeedGalleryPreview extends StatelessWidget {
  const SocialFeedGalleryPreview({required this.brightness, super.key});

  final Brightness brightness;

  @override
  Widget build(BuildContext context) {
    final dark = brightness == Brightness.dark;
    final background = dark ? SocialFeedTheme.darkBackground : SocialFeedTheme.lightBackground;
    final surface = dark ? SocialFeedTheme.darkSurface : SocialFeedTheme.lightSurface;
    final ink = dark ? const Color(0xFFF7F7F4) : const Color(0xFF141519);
    final muted = dark ? const Color(0xFFAEB1BA) : const Color(0xFF62656E);
    return Semantics(
      image: true,
      label: 'Pulse social feed preview',
      child: FittedBox(
        fit: BoxFit.fill,
        child: SizedBox(
          width: 300,
          height: 200,
          child: ColoredBox(
            color: background,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 38,
                  child: Row(
                    children: <Widget>[
                      const SizedBox(width: 14),
                      const Icon(Icons.blur_on_rounded, color: SocialFeedTheme.accent, size: 16),
                      const Spacer(),
                      Text(
                        'PULSE',
                        style: TextStyle(
                          color: ink,
                          fontFamily: SocialFeedTheme.displayFontName,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.6,
                        ),
                      ),
                      const Spacer(),
                      Icon(Icons.tune_rounded, color: muted, size: 14),
                      const SizedBox(width: 14),
                    ],
                  ),
                ),
                Container(
                  height: 40,
                  margin: const EdgeInsets.fromLTRB(12, 0, 12, 5),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: ink,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(14),
                      bottomRight: Radius.circular(14),
                    ),
                  ),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'LIVE / DESIGN WEEK',
                    style: TextStyle(
                      color: SocialFeedTheme.accent,
                      fontSize: 6,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                Expanded(
                  child: ColoredBox(
                    color: surface,
                    child: Column(
                      children: <Widget>[
                        _PreviewPost(ink: ink, muted: muted, accent: const Color(0xFFFF9B68)),
                        Divider(height: 1, color: muted.withValues(alpha: 0.25)),
                        _PreviewPost(ink: ink, muted: muted, accent: SocialFeedTheme.electricBlue),
                      ],
                    ),
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

class _PreviewPost extends StatelessWidget {
  const _PreviewPost({required this.ink, required this.muted, required this.accent});

  final Color ink;
  final Color muted;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 10, 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CircleAvatar(radius: 10, backgroundColor: accent),
            const SizedBox(width: 7),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(width: 66, height: 5, color: ink),
                  const SizedBox(height: 6),
                  Container(height: 3, color: muted.withValues(alpha: 0.5)),
                  const SizedBox(height: 3),
                  FractionallySizedBox(
                    widthFactor: 0.72,
                    child: Container(height: 3, color: muted.withValues(alpha: 0.5)),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Icon(Icons.chat_bubble_outline_rounded, size: 8, color: muted),
                      Icon(Icons.repeat_rounded, size: 8, color: muted),
                      const Icon(Icons.favorite_border_rounded, size: 8, color: SocialFeedTheme.accent),
                      Icon(Icons.bookmark_border_rounded, size: 8, color: muted),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
