import 'package:flutter/material.dart';

import '../podcast_app_theme.dart';

class PodcastGalleryPreview extends StatelessWidget {
  const PodcastGalleryPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return const FittedBox(
      fit: BoxFit.fill,
      child: SizedBox(width: 214, height: 143, child: _PodcastPreviewCanvas()),
    );
  }
}

class _PodcastPreviewCanvas extends StatelessWidget {
  const _PodcastPreviewCanvas();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: PodcastAppTheme.background,
      child: Padding(
        padding: EdgeInsets.all(11),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('WAVE', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, letterSpacing: 1.4)),
            SizedBox(height: 7),
            Text('Stories worth your time.', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
            SizedBox(height: 8),
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(child: _PreviewCover(color: PodcastAppTheme.primary)),
                  SizedBox(width: 8),
                  Expanded(child: _PreviewEpisode()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PreviewCover extends StatelessWidget {
  const _PreviewCover({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: color, borderRadius: const BorderRadius.all(Radius.circular(14))),
      child: const Center(child: Icon(Icons.graphic_eq_rounded, color: Colors.white, size: 30)),
    );
  }
}

class _PreviewEpisode extends StatelessWidget {
  const _PreviewEpisode();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(color: PodcastAppTheme.surface, borderRadius: BorderRadius.all(Radius.circular(14))),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(width: 52, child: Divider(height: 4, thickness: 4, color: PodcastAppTheme.ink)),
            SizedBox(height: 5),
            SizedBox(width: 38, child: Divider(height: 3, thickness: 3, color: PodcastAppTheme.divider)),
            Spacer(),
            Align(
              alignment: Alignment.centerRight,
              child: CircleAvatar(
                radius: 11,
                backgroundColor: PodcastAppTheme.cobalt,
                child: Icon(Icons.play_arrow_rounded, color: Colors.white, size: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
