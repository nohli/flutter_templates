import 'package:flutter/material.dart';

import '../../shared/template_gallery_preview.dart';
import '../models/social_post.dart';
import '../social_app_theme.dart';
import 'social_post_art.dart';

class SocialGalleryPreview extends StatelessWidget {
  const SocialGalleryPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return const TemplateGalleryPreviewFrame(
      background: SocialAppTheme.background,
      accent: SocialAppTheme.primary,
      primary: _SocialFeedPreview(),
      secondary: _SocialProfilePreview(),
    );
  }
}

class _SocialFeedPreview extends StatelessWidget {
  const _SocialFeedPreview();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(7, 3, 7, 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Mingle', style: TextStyle(fontSize: 7, fontWeight: FontWeight.w800, letterSpacing: -0.2)),
          SizedBox(height: 5),
          Text('Share what', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800)),
          Text('feels alive.', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800)),
          SizedBox(height: 6),
          _StoryStrip(),
          SizedBox(height: 6),
          Expanded(child: _MiniPost()),
        ],
      ),
    );
  }
}

class _SocialProfilePreview extends StatelessWidget {
  const _SocialProfilePreview();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(8, 4, 8, 3),
      child: Column(
        children: <Widget>[
          CircleAvatar(
            radius: 18,
            backgroundColor: SocialAppTheme.lavender,
            child: Text('AR', style: TextStyle(fontSize: 7, fontWeight: FontWeight.w800)),
          ),
          SizedBox(height: 5),
          Text('Ana Rivera', style: TextStyle(fontSize: 7, fontWeight: FontWeight.w800)),
          Text('Designer', style: TextStyle(fontSize: 4.5, color: SocialAppTheme.mutedInk)),
          SizedBox(height: 7),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _Metric(value: '28', label: 'Posts'),
              _Metric(value: '4.8K', label: 'Friends'),
            ],
          ),
          SizedBox(height: 7),
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                    child: SocialPostArt(artwork: SocialPostArtwork.coast, compact: true),
                  ),
                ),
                SizedBox(width: 4),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                    child: SocialPostArt(artwork: SocialPostArtwork.studio, compact: true),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StoryStrip extends StatelessWidget {
  const _StoryStrip();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: <Widget>[
        _Story(initials: 'MC', color: SocialAppTheme.coral),
        SizedBox(width: 5),
        _Story(initials: 'SO', color: SocialAppTheme.mint),
        SizedBox(width: 5),
        _Story(initials: 'AR', color: SocialAppTheme.amber),
      ],
    );
  }
}

class _Story extends StatelessWidget {
  const _Story({required this.initials, required this.color});

  final String initials;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(1.5),
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: <Color>[SocialAppTheme.primary, SocialAppTheme.coral]),
        shape: BoxShape.circle,
      ),
      child: CircleAvatar(
        radius: 8,
        backgroundColor: color,
        child: Text(initials, style: const TextStyle(fontSize: 3.5, fontWeight: FontWeight.w800)),
      ),
    );
  }
}

class _MiniPost extends StatelessWidget {
  const _MiniPost();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(9)),
        boxShadow: <BoxShadow>[BoxShadow(color: Color(0x14211D30), blurRadius: 5, offset: Offset(0, 2))],
      ),
      child: Padding(
        padding: EdgeInsets.all(4),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 6,
                  backgroundColor: SocialAppTheme.coral,
                  child: Text('MC', style: TextStyle(fontSize: 3)),
                ),
                SizedBox(width: 3),
                Text('Maya', style: TextStyle(fontSize: 4.5, fontWeight: FontWeight.w800)),
              ],
            ),
            SizedBox(height: 4),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(6)),
                child: SocialPostArt(artwork: SocialPostArtwork.sunset, compact: true),
              ),
            ),
            SizedBox(height: 3),
            Row(
              children: <Widget>[
                Icon(Icons.favorite_rounded, size: 7, color: SocialAppTheme.coral),
                SizedBox(width: 3),
                Icon(Icons.chat_bubble_outline_rounded, size: 7),
                Spacer(),
                Icon(Icons.bookmark_border_rounded, size: 7),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(value, style: const TextStyle(fontSize: 6, fontWeight: FontWeight.w800)),
        Text(label, style: const TextStyle(fontSize: 3.8, color: SocialAppTheme.mutedInk)),
      ],
    );
  }
}
