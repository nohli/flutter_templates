import 'package:flutter/material.dart';

import '../models/podcast_show.dart';
import '../podcast_app_theme.dart';
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
    return ListView(
      key: const PageStorageKey<String>('podcast-discover'),
      controller: scrollController,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
      children: <Widget>[
        const Text('Stories worth your time.', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        const Text('Thoughtful listening for curious days.', style: TextStyle(color: PodcastAppTheme.mutedInk)),
        const SizedBox(height: 20),
        TextField(
          onChanged: onQueryChanged,
          decoration: const InputDecoration(
            hintText: 'Search shows or episodes',
            prefixIcon: Icon(Icons.search_rounded),
            filled: true,
            fillColor: PodcastAppTheme.surface,
            border: OutlineInputBorder(
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
            Text('${shows.length} shows', style: const TextStyle(color: PodcastAppTheme.mutedInk)),
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
    return const Material(
      color: PodcastAppTheme.surface,
      borderRadius: BorderRadius.all(Radius.circular(24)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          children: <Widget>[
            Icon(Icons.podcasts_rounded, size: 42, color: PodcastAppTheme.primary),
            SizedBox(height: 12),
            Text('No matching shows', style: TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}
