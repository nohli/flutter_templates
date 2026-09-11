import 'package:flutter/material.dart';

import '../models/podcast_show.dart';
import '../widgets/podcast_show_card.dart';

class PodcastDiscoverSection extends StatelessWidget {
  const PodcastDiscoverSection({
    required this.shows,
    required this.selectedCategory,
    required this.savedShowIds,
    required this.scrollController,
    required this.onQueryChanged,
    required this.onCategorySelected,
    required this.onPlay,
    required this.onToggleSaved,
    super.key,
  });

  final List<PodcastShow> shows;
  final PodcastCategory selectedCategory;
  final Set<String> savedShowIds;
  final ScrollController scrollController;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<PodcastCategory> onCategorySelected;
  final ValueChanged<PodcastShow> onPlay;
  final ValueChanged<PodcastShow> onToggleSaved;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ListView(
      key: const PageStorageKey<String>('podcast-discover'),
      controller: scrollController,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
      children: <Widget>[
        const Text('Stories worth your time.', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        Text('Thoughtful listening for curious days.', style: TextStyle(color: colors.onSurfaceVariant)),
        const SizedBox(height: 20),
        TextField(
          onChanged: onQueryChanged,
          decoration: InputDecoration(
            hintText: 'Search shows or episodes',
            prefixIcon: const Icon(Icons.search_rounded),
            filled: true,
            fillColor: colors.surface,
            border: const OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(18)),
            ),
          ),
        ),
        const SizedBox(height: 18),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              for (final category in PodcastCategory.values) ...<Widget>[
                ChoiceChip(
                  label: Text(_labelFor(category)),
                  selected: category == selectedCategory,
                  onSelected: (_) => onCategorySelected(category),
                ),
                if (category != PodcastCategory.values.last) const SizedBox(width: 8),
              ],
            ],
          ),
        ),
        const SizedBox(height: 22),
        Row(
          children: <Widget>[
            const Expanded(
              child: Text('Fresh episodes', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            ),
            Text('${shows.length} shows', style: TextStyle(color: colors.onSurfaceVariant)),
          ],
        ),
        const SizedBox(height: 12),
        if (shows.isEmpty)
          const _EmptyPodcastState()
        else
          for (final show in shows) ...<Widget>[
            PodcastShowCard(
              show: show,
              isSaved: savedShowIds.contains(show.id),
              onPlay: () => onPlay(show),
              onToggleSaved: () => onToggleSaved(show),
            ),
            if (show != shows.last) const SizedBox(height: 12),
          ],
      ],
    );
  }

  String _labelFor(PodcastCategory category) => switch (category) {
    PodcastCategory.all => 'All',
    PodcastCategory.design => 'Design',
    PodcastCategory.culture => 'Culture',
    PodcastCategory.science => 'Science',
  };
}

class _EmptyPodcastState extends StatelessWidget {
  const _EmptyPodcastState();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Material(
      color: colors.surface,
      borderRadius: const BorderRadius.all(Radius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          children: <Widget>[
            Icon(Icons.podcasts_rounded, size: 42, color: colors.primary),
            const SizedBox(height: 12),
            const Text('No matching shows', style: TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}
