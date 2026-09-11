import 'package:flutter/material.dart';

import '../models/podcast_show.dart';
import '../podcast_app_theme.dart';
import '../widgets/podcast_vinyl.dart';

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
    final largeText = MediaQuery.textScalerOf(context).scale(1) >= 2;

    return ListView(
      key: const PageStorageKey<String>('podcast-player'),
      controller: scrollController,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
      children: <Widget>[
        if (largeText)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text('Now playing', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900)),
              const SizedBox(height: 6),
              Text('WAVE / LIVE 072', style: TextStyle(color: colors.onSurfaceVariant, fontSize: 9)),
            ],
          )
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              const Expanded(
                child: Text(
                  'Now playing',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1.4),
                ),
              ),
              Text('WAVE / LIVE 072', style: TextStyle(color: colors.onSurfaceVariant, fontSize: 9)),
            ],
          ),
        const SizedBox(height: 12),
        _Turntable(show: show, isPlaying: isPlaying),
        const SizedBox(height: 20),
        Text(
          show.title,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: -1.1, height: 0.95),
        ),
        const SizedBox(height: 7),
        Text(show.episodeTitle, style: TextStyle(color: colors.onSurfaceVariant, fontSize: 15, height: 1.3)),
        const SizedBox(height: 18),
        DecoratedBox(
          decoration: BoxDecoration(
            color: colors.surface,
            border: Border.all(color: colors.outlineVariant),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Slider(value: progress, onChanged: onProgressChanged),
          ),
        ),
        const SizedBox(height: 8),
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
        const SizedBox(height: 14),
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 12,
          runSpacing: 12,
          children: <Widget>[
            OutlinedButton(onPressed: onCycleSpeed, child: Text('$speed×')),
            IconButton.filledTonal(
              tooltip: 'Rewind sample progress',
              onPressed: () => onProgressChanged((progress - 0.05).clamp(0, 1)),
              icon: const Icon(Icons.replay_10_rounded),
            ),
            IconButton.filled(
              tooltip: isPlaying ? 'Pause episode' : 'Play episode',
              iconSize: 36,
              onPressed: onTogglePlayback,
              style: IconButton.styleFrom(
                minimumSize: const Size.square(64),
                backgroundColor: PodcastAppTheme.primary,
                foregroundColor: PodcastAppTheme.ink,
              ),
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

class _Turntable extends StatelessWidget {
  const _Turntable({required this.show, required this.isPlaying});

  final PodcastShow show;
  final bool isPlaying;

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    return SizedBox(
      height: 276,
      child: DecoratedBox(
        decoration: const BoxDecoration(color: PodcastAppTheme.ink),
        child: Stack(
          children: <Widget>[
            const Positioned(
              left: 14,
              top: 12,
              child: Text(
                'STEREO / 33⅓ RPM',
                style: TextStyle(color: PodcastAppTheme.signal, fontSize: 8, fontWeight: FontWeight.w900),
              ),
            ),
            Positioned(
              left: 18,
              top: 38,
              width: 220,
              height: 220,
              child: AnimatedRotation(
                turns: isPlaying ? 1 : 0,
                duration: reduceMotion ? Duration.zero : const Duration(milliseconds: 900),
                curve: Curves.easeOutCubic,
                child: PodcastVinyl(show: show),
              ),
            ),
            Positioned(
              right: 22,
              top: 40,
              child: Column(
                children: <Widget>[
                  const DecoratedBox(
                    decoration: BoxDecoration(color: PodcastAppTheme.signal, shape: BoxShape.circle),
                    child: SizedBox.square(dimension: 32),
                  ),
                  Transform.rotate(
                    angle: isPlaying ? 0.24 : -0.12,
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: 8,
                      height: 154,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFFCF0),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 14,
              bottom: 14,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: isPlaying ? PodcastAppTheme.primary : const Color(0xFF5B574D),
                  shape: BoxShape.circle,
                ),
                child: const SizedBox.square(dimension: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
