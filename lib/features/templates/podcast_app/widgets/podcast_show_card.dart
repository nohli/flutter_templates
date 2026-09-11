import 'package:flutter/material.dart';

import '../models/podcast_show.dart';
import '../podcast_app_theme.dart';
import 'podcast_vinyl.dart';

class PodcastShowCard extends StatelessWidget {
  const PodcastShowCard({
    required this.show,
    required this.isSaved,
    required this.onPlay,
    required this.onToggleSaved,
    super.key,
  });

  final PodcastShow show;
  final bool isSaved;
  final VoidCallback onPlay;
  final VoidCallback onToggleSaved;

  @override
  Widget build(BuildContext context) {
    final usesLargeText = MediaQuery.textScalerOf(context).scale(1) >= 2;
    final colors = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: MediaQuery.disableAnimationsOf(context) ? Duration.zero : const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: isSaved ? colors.primaryContainer.withValues(alpha: 0.55) : colors.surface,
        border: Border.all(color: isSaved ? colors.primary : colors.outlineVariant, width: 1.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: usesLargeText ? _largeTextLayout() : _standardLayout(),
        ),
      ),
    );
  }

  Widget _standardLayout() {
    return Row(
      children: <Widget>[
        SizedBox.square(dimension: 82, child: PodcastVinyl(show: show, compact: true)),
        const SizedBox(width: 12),
        Expanded(child: _ShowDetails(show: show)),
        const SizedBox(width: 6),
        _ShowActions(show: show, isSaved: isSaved, onPlay: onPlay, onToggleSaved: onToggleSaved),
      ],
    );
  }

  Widget _largeTextLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: SizedBox.square(dimension: 150, child: PodcastVinyl(show: show)),
        ),
        const SizedBox(height: 14),
        _ShowDetails(show: show),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerRight,
          child: _ShowActions(show: show, isSaved: isSaved, onPlay: onPlay, onToggleSaved: onToggleSaved),
        ),
      ],
    );
  }
}

class _ShowDetails extends StatelessWidget {
  const _ShowDetails({required this.show});

  final PodcastShow show;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          _episodeNumber(show),
          style: TextStyle(color: colors.primary, fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 1.2),
        ),
        const SizedBox(height: 4),
        Text(show.title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
        const SizedBox(height: 4),
        Text(
          show.author.toUpperCase(),
          style: TextStyle(color: colors.onSurfaceVariant, fontSize: 9, letterSpacing: 0.8),
        ),
        const SizedBox(height: 7),
        Text(show.episodeTitle, style: TextStyle(color: colors.onSurfaceVariant, fontSize: 12, height: 1.35)),
        const SizedBox(height: 8),
        DecoratedBox(
          decoration: const BoxDecoration(color: PodcastAppTheme.signal),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            child: Text(show.durationLabel, style: const TextStyle(color: PodcastAppTheme.ink, fontSize: 9)),
          ),
        ),
      ],
    );
  }

  String _episodeNumber(PodcastShow show) => switch (show.tone) {
    PodcastTone.coral => 'EPISODE 01',
    PodcastTone.cobalt => 'EPISODE 02',
    PodcastTone.sky => 'EPISODE 03',
    PodcastTone.sage => 'EPISODE 04',
  };
}

class _ShowActions extends StatelessWidget {
  const _ShowActions({required this.show, required this.isSaved, required this.onPlay, required this.onToggleSaved});

  final PodcastShow show;
  final bool isSaved;
  final VoidCallback onPlay;
  final VoidCallback onToggleSaved;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        IconButton.filled(
          tooltip: 'Play ${show.title}',
          onPressed: onPlay,
          style: IconButton.styleFrom(shape: const CircleBorder()),
          icon: const Icon(Icons.play_arrow_rounded),
        ),
        IconButton(
          tooltip: isSaved ? 'Remove ${show.title} from library' : 'Save ${show.title} to library',
          onPressed: onToggleSaved,
          icon: Icon(isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded),
        ),
      ],
    );
  }
}
