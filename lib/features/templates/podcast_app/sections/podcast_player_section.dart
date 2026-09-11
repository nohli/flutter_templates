import 'package:flutter/material.dart';

import '../models/podcast_show.dart';
import '../widgets/podcast_artwork.dart';

class PodcastPlayerSection extends StatelessWidget {
  const PodcastPlayerSection({
    required this.show,
    required this.isPlaying,
    required this.progress,
    required this.speed,
    required this.scrollController,
    required this.onTogglePlayback,
    required this.onProgressChanged,
    required this.onCycleSpeed,
    super.key,
  });

  final PodcastShow show;
  final bool isPlaying;
  final double progress;
  final double speed;
  final ScrollController scrollController;
  final VoidCallback onTogglePlayback;
  final ValueChanged<double> onProgressChanged;
  final VoidCallback onCycleSpeed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ListView(
      key: const PageStorageKey<String>('podcast-player'),
      controller: scrollController,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      padding: const EdgeInsets.fromLTRB(24, 4, 24, 32),
      children: <Widget>[
        const Text('Now playing', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
        const SizedBox(height: 20),
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: AspectRatio(aspectRatio: 1, child: PodcastArtwork(show: show)),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          show.title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        Text(
          show.episodeTitle,
          textAlign: TextAlign.center,
          style: TextStyle(color: colors.onSurfaceVariant),
        ),
        const SizedBox(height: 22),
        Slider(value: progress, onChanged: onProgressChanged),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: <Widget>[
              Text(
                '${(progress * show.durationMinutes).round()} min',
                style: TextStyle(color: colors.onSurfaceVariant),
              ),
              const Spacer(),
              Text(show.durationLabel, style: TextStyle(color: colors.onSurfaceVariant)),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 18,
          runSpacing: 12,
          children: <Widget>[
            TextButton(onPressed: onCycleSpeed, child: Text('$speed×')),
            IconButton.filledTonal(
              tooltip: 'Rewind sample progress',
              onPressed: () => onProgressChanged((progress - 0.05).clamp(0, 1)),
              icon: const Icon(Icons.replay_10_rounded),
            ),
            IconButton.filled(
              tooltip: isPlaying ? 'Pause episode' : 'Play episode',
              iconSize: 34,
              onPressed: onTogglePlayback,
              icon: Icon(isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded),
            ),
            IconButton.filledTonal(
              tooltip: 'Forward sample progress',
              onPressed: () => onProgressChanged((progress + 0.05).clamp(0, 1)),
              icon: const Icon(Icons.forward_10_rounded),
            ),
            IconButton(
              tooltip: 'More playback options',
              onPressed: () => ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Playback options are shown as an interface preview.'))),
              icon: const Icon(Icons.more_horiz_rounded),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'This template demonstrates local player state and does not stream audio.',
          textAlign: TextAlign.center,
          style: TextStyle(color: colors.onSurfaceVariant, fontSize: 12),
        ),
      ],
    );
  }
}
