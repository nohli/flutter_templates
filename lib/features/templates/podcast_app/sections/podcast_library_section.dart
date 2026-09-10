import 'package:flutter/material.dart';

import '../models/podcast_show.dart';
import '../podcast_app_theme.dart';
import '../widgets/podcast_show_card.dart';

class PodcastLibrarySection extends StatelessWidget {
  const PodcastLibrarySection({
    required this.shows,
    required this.downloadedShowIds,
    required this.scrollController,
    required this.onPlay,
    required this.onRemove,
    required this.onToggleDownloaded,
    super.key,
  });

  final List<PodcastShow> shows;
  final Set<String> downloadedShowIds;
  final ScrollController scrollController;
  final ValueChanged<PodcastShow> onPlay;
  final ValueChanged<PodcastShow> onRemove;
  final ValueChanged<PodcastShow> onToggleDownloaded;

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const PageStorageKey<String>('podcast-library'),
      controller: scrollController,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
      children: <Widget>[
        const Text('Your library', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        const Text('Saved episodes stay local to this sample.', style: TextStyle(color: PodcastAppTheme.mutedInk)),
        const SizedBox(height: 20),
        if (shows.isEmpty)
          const _EmptyLibraryState()
        else
          for (final show in shows) ...<Widget>[
            PodcastShowCard(show: show, isSaved: true, onPlay: () => onPlay(show), onToggleSaved: () => onRemove(show)),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => onToggleDownloaded(show),
                icon: Icon(downloadedShowIds.contains(show.id) ? Icons.download_done_rounded : Icons.download_rounded),
                label: Text(downloadedShowIds.contains(show.id) ? 'Downloaded' : 'Download sample'),
              ),
            ),
            if (show != shows.last) const Divider(color: PodcastAppTheme.divider),
          ],
      ],
    );
  }
}

class _EmptyLibraryState extends StatelessWidget {
  const _EmptyLibraryState();

  @override
  Widget build(BuildContext context) {
    return const Material(
      color: PodcastAppTheme.surface,
      borderRadius: BorderRadius.all(Radius.circular(26)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 42),
        child: Column(
          children: <Widget>[
            Icon(Icons.bookmarks_outlined, size: 44, color: PodcastAppTheme.primary),
            SizedBox(height: 12),
            Text('Build your listening queue', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            SizedBox(height: 6),
            Text('Save a show in Discover to see it here.', textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
