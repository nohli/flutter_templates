import 'package:flutter/material.dart';

import '../models/podcast_section.dart';
import '../models/podcast_show.dart';
import 'podcast_artwork.dart';

class PodcastNavigationDrawer extends StatelessWidget {
  const PodcastNavigationDrawer({
    required this.selectedSection,
    required this.currentShow,
    required this.onSelected,
    super.key,
  });

  final PodcastSection selectedSection;
  final PodcastShow currentShow;
  final ValueChanged<PodcastSection> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Drawer(
      backgroundColor: colors.surface,
      child: SafeArea(
        child: ListView(
          primary: false,
          padding: EdgeInsets.zero,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Wave',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  Text('Your listening space', style: TextStyle(color: colors.onSurfaceVariant)),
                ],
              ),
            ),
            Divider(height: 1, color: colors.outlineVariant),
            const SizedBox(height: 10),
            for (final section in PodcastSection.values)
              ListTile(
                selected: selectedSection == section,
                leading: Icon(_iconFor(section)),
                title: Text(_labelFor(section)),
                subtitle: section == PodcastSection.player
                    ? Text(currentShow.title, maxLines: 1, overflow: TextOverflow.ellipsis)
                    : null,
                onTap: () {
                  Navigator.of(context).pop();
                  onSelected(section);
                },
              ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: <Widget>[
                  SizedBox.square(dimension: 52, child: PodcastArtwork(show: currentShow, compact: true)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      currentShow.episodeTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _labelFor(PodcastSection section) => switch (section) {
    PodcastSection.discover => 'Discover',
    PodcastSection.library => 'Library',
    PodcastSection.player => 'Now playing',
  };

  IconData _iconFor(PodcastSection section) => switch (section) {
    PodcastSection.discover => Icons.explore_outlined,
    PodcastSection.library => Icons.bookmarks_outlined,
    PodcastSection.player => Icons.graphic_eq_rounded,
  };
}
