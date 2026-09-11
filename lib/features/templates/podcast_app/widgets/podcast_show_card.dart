import 'package:flutter/material.dart';

import '../models/podcast_show.dart';
import 'podcast_artwork.dart';

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
        border: Border.all(color: isSaved ? colors.primary : Colors.transparent, width: 1.5),
        borderRadius: const BorderRadius.all(Radius.circular(26)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: usesLargeText ? _largeTextLayout() : _standardLayout(),
        ),
      ),
    );
  }

  Widget _standardLayout() {
    return Row(
      children: <Widget>[
        SizedBox.square(dimension: 104, child: PodcastArtwork(show: show, compact: true)),
        const SizedBox(width: 14),
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
        AspectRatio(aspectRatio: 1.6, child: PodcastArtwork(show: show)),
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
        Text(show.title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
        const SizedBox(height: 4),
        Text(show.author, style: TextStyle(color: colors.primary, fontSize: 12)),
        const SizedBox(height: 7),
        Text(show.episodeTitle, style: TextStyle(color: colors.onSurfaceVariant, fontSize: 12, height: 1.35)),
        const SizedBox(height: 7),
        Text(show.durationLabel, style: TextStyle(color: colors.onSurfaceVariant, fontSize: 11)),
      ],
    );
  }
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
        IconButton.filled(tooltip: 'Play ${show.title}', onPressed: onPlay, icon: const Icon(Icons.play_arrow_rounded)),
        IconButton(
          tooltip: isSaved ? 'Remove ${show.title} from library' : 'Save ${show.title} to library',
          onPressed: onToggleSaved,
          icon: Icon(isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded),
        ),
      ],
    );
  }
}
