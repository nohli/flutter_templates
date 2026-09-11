import 'package:flutter/material.dart';

import '../models/social_post.dart';
import '../social_app_theme.dart';
import '../widgets/social_post_art.dart';

class SocialProfileSection extends StatelessWidget {
  const SocialProfileSection({
    required this.scrollController,
    required this.posts,
    required this.savedPostCount,
    required this.isPrivate,
    required this.onPrivateChanged,
    super.key,
  });

  final ScrollController scrollController;
  final List<SocialPost> posts;
  final int savedPostCount;
  final bool isPrivate;
  final ValueChanged<bool> onPrivateChanged;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 32),
      children: <Widget>[
        const _ProfileHeader(),
        const SizedBox(height: 22),
        Row(
          children: <Widget>[
            const Expanded(
              child: _ProfileMetric(value: '28', label: 'Posts'),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: _ProfileMetric(value: '4.8K', label: 'Friends'),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _ProfileMetric(value: '$savedPostCount', label: 'Saved'),
            ),
          ],
        ),
        const SizedBox(height: 24),
        SwitchListTile.adaptive(
          value: isPrivate,
          onChanged: onPrivateChanged,
          tileColor: colors.surface,
          shape: RoundedRectangleBorder(side: BorderSide(color: colors.outlineVariant)),
          secondary: Icon(Icons.lock_outline_rounded, color: colors.primary),
          title: const Text('Private profile', style: TextStyle(fontWeight: FontWeight.w800)),
          subtitle: const Text('Approve new followers.'),
        ),
        const SizedBox(height: 26),
        const Text(
          'RECENT / FIELD NOTES',
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.2),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          primary: false,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: posts.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemBuilder: (BuildContext context, int index) {
            final post = posts[index];
            return DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: SocialAppTheme.ink, width: 2),
                boxShadow: SocialAppTheme.softShadow,
              ),
              child: SocialPostArt(artwork: post.artwork),
            );
          },
        ),
      ],
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(color: SocialAppTheme.primary),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: <Widget>[
            DecoratedBox(
              decoration: BoxDecoration(
                color: SocialAppTheme.amber,
                boxShadow: <BoxShadow>[BoxShadow(color: SocialAppTheme.ink, offset: Offset(4, 4))],
              ),
              child: SizedBox.square(
                dimension: 72,
                child: Center(
                  child: Text(
                    'AR',
                    style: TextStyle(color: SocialAppTheme.ink, fontSize: 24, fontWeight: FontWeight.w900),
                  ),
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Ana Rivera',
                    style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w900),
                  ),
                  SizedBox(height: 5),
                  Text('Designer · Collector of small joys', style: TextStyle(color: Color(0xD1FFFFFF))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileMetric extends StatelessWidget {
  const _ProfileMetric({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border.all(color: SocialAppTheme.ink),
      ),
      child: Column(
        children: <Widget>[
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 3),
          Text(label, style: TextStyle(color: colors.onSurfaceVariant, fontSize: 12)),
        ],
      ),
    );
  }
}
