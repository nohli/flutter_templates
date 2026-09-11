import 'package:flutter/material.dart';

import '../../shared/template_gallery_preview.dart';
import '../podcast_app_theme.dart';

class PodcastGalleryPreview extends StatelessWidget {
  const PodcastGalleryPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return const TemplateGalleryPreviewFrame(
      background: PodcastAppTheme.background,
      accent: PodcastAppTheme.cobalt,
      primary: _PodcastDiscoverPreview(),
      secondary: _PodcastPlayerPreview(),
    );
  }
}

class _PodcastDiscoverPreview extends StatelessWidget {
  const _PodcastDiscoverPreview();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(7, 3, 7, 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('WAVE', style: TextStyle(fontSize: 7, fontWeight: FontWeight.w800, letterSpacing: 0.9)),
          SizedBox(height: 4),
          Text('Stories worth', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800)),
          Text('your time.', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800)),
          SizedBox(height: 4),
          _PodcastRow(titleWidth: 37, color: PodcastAppTheme.primary),
          SizedBox(height: 3),
          _PodcastRow(titleWidth: 32, color: PodcastAppTheme.cobalt),
          SizedBox(height: 3),
          _PodcastRow(titleWidth: 40, color: PodcastAppTheme.sky),
          SizedBox(height: 3),
          _PodcastRow(titleWidth: 29, color: PodcastAppTheme.sage),
        ],
      ),
    );
  }
}

class _PodcastPlayerPreview extends StatelessWidget {
  const _PodcastPlayerPreview();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(9, 3, 9, 3),
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Text('Now playing', style: TextStyle(fontSize: 7.5, fontWeight: FontWeight.w800)),
          ),
          SizedBox(height: 5),
          SizedBox.square(dimension: 45, child: _PodcastCover(color: PodcastAppTheme.primary)),
          SizedBox(height: 5),
          Text('Small Wonders', style: TextStyle(fontSize: 6.5, fontWeight: FontWeight.w800)),
          SizedBox(height: 2),
          Text('Mira Cole', style: TextStyle(fontSize: 4.5, color: PodcastAppTheme.primary)),
          Spacer(),
          _PlaybackProgress(),
          SizedBox(height: 4),
          _PlaybackControls(),
        ],
      ),
    );
  }
}

class _PodcastRow extends StatelessWidget {
  const _PodcastRow({required this.titleWidth, required this.color});

  final double titleWidth;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      padding: const EdgeInsets.all(3),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(7)),
        boxShadow: <BoxShadow>[BoxShadow(color: Color(0x10171C33), blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Row(
        children: <Widget>[
          SizedBox.square(dimension: 14, child: _PodcastCover(color: color)),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                PreviewLine(width: titleWidth, height: 2.5, color: PodcastAppTheme.ink),
                const SizedBox(height: 3),
                PreviewLine(width: titleWidth * 0.7, height: 2, color: PodcastAppTheme.divider),
              ],
            ),
          ),
          const Icon(Icons.play_circle_fill_rounded, size: 9, color: PodcastAppTheme.primary),
        ],
      ),
    );
  }
}

class _PodcastCover extends StatelessWidget {
  const _PodcastCover({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[color, Color.lerp(color, Colors.black, 0.24)!],
        ),
        borderRadius: const BorderRadius.all(Radius.circular(9)),
      ),
      child: const Center(child: Icon(Icons.graphic_eq_rounded, color: Colors.white, size: 18)),
    );
  }
}

class _PlaybackProgress extends StatelessWidget {
  const _PlaybackProgress();

  @override
  Widget build(BuildContext context) {
    return const Stack(
      alignment: Alignment.centerLeft,
      children: <Widget>[
        PreviewLine(width: 78, height: 3, color: PodcastAppTheme.divider),
        PreviewLine(width: 34, height: 3, color: PodcastAppTheme.cobalt),
      ],
    );
  }
}

class _PlaybackControls extends StatelessWidget {
  const _PlaybackControls();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.replay_10_rounded, size: 9, color: PodcastAppTheme.ink),
        SizedBox(width: 7),
        CircleAvatar(
          radius: 8,
          backgroundColor: PodcastAppTheme.cobalt,
          child: Icon(Icons.pause_rounded, color: Colors.white, size: 9),
        ),
        SizedBox(width: 7),
        Icon(Icons.forward_30_rounded, size: 9, color: PodcastAppTheme.ink),
      ],
    );
  }
}
