import 'package:flutter/material.dart';

import '../models/podcast_show.dart';
import '../podcast_app_theme.dart';

class PodcastArtwork extends StatelessWidget {
  const PodcastArtwork({required this.show, this.compact = false, super.key});

  final PodcastShow show;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = _colorsFor(show.tone);
    final barHeights = compact ? const <double>[16, 28, 20, 34, 15] : const <double>[28, 52, 38, 68, 24];

    return Semantics(
      image: true,
      label: '${show.title} podcast cover',
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(compact ? 16 : 28)),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
          ),
          child: Stack(
            children: <Widget>[
              Positioned(
                top: compact ? -18 : -42,
                right: compact ? -14 : -34,
                child: CircleAvatar(radius: compact ? 34 : 72, backgroundColor: Colors.white.withValues(alpha: 0.18)),
              ),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    for (var index = 0; index < barHeights.length; index++) ...<Widget>[
                      Container(
                        width: compact ? 5 : 9,
                        height: barHeights[index],
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                      if (index < barHeights.length - 1) SizedBox(width: compact ? 4 : 7),
                    ],
                  ],
                ),
              ),
              Positioned(
                left: compact ? 10 : 20,
                bottom: compact ? 8 : 18,
                right: compact ? 10 : 20,
                child: Text(
                  show.title.toUpperCase(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: compact ? 8 : 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Color> _colorsFor(PodcastTone tone) => switch (tone) {
    PodcastTone.coral => const <Color>[PodcastAppTheme.primary, Color(0xFF7A3041)],
    PodcastTone.cobalt => const <Color>[PodcastAppTheme.cobalt, Color(0xFF27206D)],
    PodcastTone.sky => const <Color>[PodcastAppTheme.sky, Color(0xFF164453)],
    PodcastTone.sage => const <Color>[PodcastAppTheme.sage, Color(0xFF294C34)],
  };
}
