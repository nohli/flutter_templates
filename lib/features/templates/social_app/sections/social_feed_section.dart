import 'package:flutter/material.dart';

import '../models/social_post.dart';
import '../social_app_theme.dart';
import '../widgets/social_post_card.dart';

class SocialFeedSection extends StatelessWidget {
  const SocialFeedSection({
    required this.posts,
    required this.likedPostIds,
    required this.savedPostIds,
    required this.scrollController,
    required this.onToggleLiked,
    required this.onToggleSaved,
    required this.onPreviewAction,
    super.key,
  });

  final List<SocialPost> posts;
  final Set<String> likedPostIds;
  final Set<String> savedPostIds;
  final ScrollController scrollController;
  final ValueChanged<SocialPost> onToggleLiked;
  final ValueChanged<SocialPost> onToggleSaved;
  final ValueChanged<String> onPreviewAction;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 32),
      children: <Widget>[
        const Text(
          'Share what feels alive.',
          style: TextStyle(fontSize: 34, height: 1.05, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 12),
        Text('Small moments from a thoughtful community.', style: TextStyle(color: colors.onSurfaceVariant)),
        const SizedBox(height: 22),
        const _StoryRow(),
        const SizedBox(height: 24),
        ...posts.map(
          (SocialPost post) => Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: SocialPostCard(
              post: post,
              isLiked: likedPostIds.contains(post.id),
              isSaved: savedPostIds.contains(post.id),
              onToggleLiked: () => onToggleLiked(post),
              onToggleSaved: () => onToggleSaved(post),
              onPreviewAction: onPreviewAction,
            ),
          ),
        ),
      ],
    );
  }
}

class _StoryRow extends StatelessWidget {
  const _StoryRow();

  static const _stories = <({Color color, String initials, String name})>[
    (initials: 'You', name: 'Your story', color: SocialAppTheme.lavender),
    (initials: 'MC', name: 'Maya', color: SocialAppTheme.coral),
    (initials: 'SO', name: 'Sam', color: SocialAppTheme.mint),
    (initials: 'AR', name: 'Ana', color: SocialAppTheme.amber),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 92,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _stories.length,
        separatorBuilder: (BuildContext context, int index) => const SizedBox(width: 14),
        itemBuilder: (BuildContext context, int index) {
          final story = _stories[index];
          return SizedBox(
            width: 66,
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: <Color>[SocialAppTheme.primary, SocialAppTheme.coral]),
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    radius: 28,
                    backgroundColor: story.color,
                    child: Text(
                      story.initials,
                      style: const TextStyle(color: SocialAppTheme.ink, fontSize: 12, fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(story.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11)),
              ],
            ),
          );
        },
      ),
    );
  }
}
