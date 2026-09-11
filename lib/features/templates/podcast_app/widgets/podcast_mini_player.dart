import 'package:flutter/material.dart';

import '../models/podcast_show.dart';
import '../podcast_app_theme.dart';
import 'podcast_vinyl.dart';

class PodcastMiniPlayer extends StatelessWidget {
  const PodcastMiniPlayer({
    required this.show,
    required this.isPlaying,
    required this.progress,
    required this.onOpen,
    required this.onTogglePlayback,
    super.key,
  });

  final PodcastShow show;
  final bool isPlaying;
  final double progress;
  final VoidCallback onOpen;
  final VoidCallback onTogglePlayback;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Material(
      color: PodcastAppTheme.ink,
      shape: Border(top: BorderSide(color: colors.primary, width: 3)),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            LinearProgressIndicator(
              value: progress,
              minHeight: 3,
              color: PodcastAppTheme.signal,
              backgroundColor: const Color(0xFF4B473D),
            ),
            InkWell(
              onTap: onOpen,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 10, 8, 10),
                child: Row(
                  children: <Widget>[
                    SizedBox.square(dimension: 48, child: PodcastVinyl(show: show, compact: true)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            show.title.toUpperCase(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFFFFFCF0),
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.7,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            show.episodeTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Color(0xB3FFFCF0), fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: isPlaying ? 'Pause mini player' : 'Play mini player',
                      onPressed: onTogglePlayback,
                      icon: Icon(isPlaying ? Icons.pause_circle_filled_rounded : Icons.play_circle_fill_rounded),
                      iconSize: 36,
                      color: PodcastAppTheme.signal,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
