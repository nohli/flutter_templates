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
    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 32),
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
          tileColor: SocialAppTheme.surface,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
          secondary: const Icon(Icons.lock_outline_rounded, color: SocialAppTheme.primary),
          title: const Text('Private profile', style: TextStyle(fontWeight: FontWeight.w800)),
          subtitle: const Text('Approve new followers.'),
        ),
        const SizedBox(height: 26),
        const Text('Recent moments', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
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
            return ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
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
    return const Row(
      children: <Widget>[
        CircleAvatar(
          radius: 42,
          backgroundColor: SocialAppTheme.lavender,
          child: Text('AR', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Ana Rivera', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800)),
              SizedBox(height: 5),
              Text('Designer · Collector of small joys', style: TextStyle(color: SocialAppTheme.mutedInk)),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProfileMetric extends StatelessWidget {
  const _ProfileMetric({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: const BoxDecoration(
        color: SocialAppTheme.surface,
        borderRadius: BorderRadius.all(Radius.circular(18)),
      ),
      child: Column(
        children: <Widget>[
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 3),
          Text(label, style: const TextStyle(color: SocialAppTheme.mutedInk, fontSize: 12)),
        ],
      ),
    );
  }
}
