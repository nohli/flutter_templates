import 'package:flutter/material.dart';

import '../models/podcast_show.dart';
import 'podcast_artwork.dart';

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
      color: colors.surface,
      elevation: 12,
      shadowColor: Colors.black26,
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            LinearProgressIndicator(value: progress, minHeight: 3),
            InkWell(
              onTap: onOpen,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 10, 8, 10),
                child: Row(
                  children: <Widget>[
                    SizedBox.square(dimension: 48, child: PodcastArtwork(show: show, compact: true)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(show.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 3),
                          Text(
                            show.episodeTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: colors.onSurfaceVariant, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: isPlaying ? 'Pause mini player' : 'Play mini player',
                      onPressed: onTogglePlayback,
                      icon: Icon(isPlaying ? Icons.pause_circle_filled_rounded : Icons.play_circle_fill_rounded),
                      iconSize: 36,
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
