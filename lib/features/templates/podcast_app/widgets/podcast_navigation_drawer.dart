import 'package:flutter/material.dart';

import '../models/podcast_section.dart';
import '../models/podcast_show.dart';
import '../podcast_app_theme.dart';
import 'podcast_vinyl.dart';

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
    return Drawer(
      backgroundColor: PodcastAppTheme.ink,
      shape: const RoundedRectangleBorder(),
      child: SafeArea(
        child: ListView(
          primary: false,
          padding: EdgeInsets.zero,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 24, 24, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'WAVE / 072',
                    style: TextStyle(
                      color: PodcastAppTheme.signal,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.4,
                    ),
                  ),
                  SizedBox(height: 14),
                  Text(
                    'TUNE YOUR\nLISTENING.',
                    style: TextStyle(
                      color: Color(0xFFFFFCF0),
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1,
                      height: 0.9,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFF4B473D)),
            const SizedBox(height: 10),
            for (final section in PodcastSection.values)
              ListTile(
                selected: selectedSection == section,
                selectedTileColor: PodcastAppTheme.primary,
                iconColor: PodcastAppTheme.signal,
                textColor: const Color(0xFFFFFCF0),
                selectedColor: PodcastAppTheme.ink,
                shape: const RoundedRectangleBorder(),
                leading: Icon(_iconFor(section)),
                title: Text(_labelFor(section), style: const TextStyle(fontWeight: FontWeight.w800)),
                subtitle: section == PodcastSection.player
                    ? Text(
                        currentShow.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Color(0xB3FFFCF0)),
                      )
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
                  SizedBox.square(dimension: 52, child: PodcastVinyl(show: currentShow, compact: true)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      currentShow.episodeTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Color(0xFFFFFCF0), fontWeight: FontWeight.w700),
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
