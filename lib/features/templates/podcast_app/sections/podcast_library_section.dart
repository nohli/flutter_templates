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
    final colors = Theme.of(context).colorScheme;

    return ListView(
      key: const PageStorageKey<String>('podcast-library'),
      controller: scrollController,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
      children: <Widget>[
        const Text(
          'ARCHIVE / SAVED SIGNALS',
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.3),
        ),
        const SizedBox(height: 10),
        const Text(
          'Your library',
          style: TextStyle(
            fontFamily: PodcastAppTheme.displayFontName,
            fontSize: 28,
            fontWeight: FontWeight.w400,
            letterSpacing: -0.7,
          ),
        ),
        const SizedBox(height: 6),
        Text('Episodes worth another listen.', style: TextStyle(color: colors.onSurfaceVariant)),
        const SizedBox(height: 18),
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
            if (show != shows.last) Divider(color: colors.outlineVariant),
          ],
      ],
    );
  }
}

class _EmptyLibraryState extends StatelessWidget {
  const _EmptyLibraryState();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Material(
      color: colors.surface,
      shape: RoundedRectangleBorder(side: BorderSide(color: colors.outlineVariant)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 42),
        child: Column(
          children: <Widget>[
            Icon(Icons.bookmarks_outlined, size: 44, color: colors.primary),
            const SizedBox(height: 12),
            const Text('Build your listening queue', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            const Text('Save a show in Discover to see it here.', textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
