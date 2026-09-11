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
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      children: <Widget>[
        const _ZineHero(),
        const SizedBox(height: 10),
        Text(
          'Share what feels alive.',
          style: TextStyle(color: colors.onSurfaceVariant, fontSize: 12, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 14),
        const _StoryRow(),
        const SizedBox(height: 18),
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

class _ZineHero extends StatelessWidget {
  const _ZineHero();

  @override
  Widget build(BuildContext context) {
    final largeText = MediaQuery.textScalerOf(context).scale(1) >= 2;

    if (largeText) {
      return const DecoratedBox(
        decoration: BoxDecoration(color: SocialAppTheme.primary),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Good people. Good energy.',
            style: TextStyle(
              color: Colors.white,
              fontFamily: SocialAppTheme.displayFontName,
              fontSize: 20,
              fontWeight: FontWeight.w800,
              height: 0.95,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 132,
      child: DecoratedBox(
        decoration: const BoxDecoration(color: SocialAppTheme.primary),
        child: Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            const Positioned(
              left: 15,
              top: 12,
              child: Text(
                'MINGLE PAPER / VOL. 04',
                style: TextStyle(color: SocialAppTheme.amber, fontSize: 7, fontWeight: FontWeight.w900),
              ),
            ),
            const Positioned(
              left: 15,
              bottom: 15,
              child: Text(
                'GOOD PEOPLE.\nGOOD ENERGY.',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: SocialAppTheme.displayFontName,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.8,
                  height: 0.88,
                ),
              ),
            ),
            Positioned(
              right: 18,
              top: 18,
              child: Transform.rotate(
                angle: 0.12,
                child: const DecoratedBox(
                  decoration: BoxDecoration(color: SocialAppTheme.amber),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                    child: Text(
                      'MAKE\nSOMETHING\nREAL',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: SocialAppTheme.ink,
                        fontSize: 8,
                        fontWeight: FontWeight.w900,
                        height: 1.05,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Positioned(
              right: 26,
              bottom: 12,
              child: Icon(Icons.auto_awesome, color: SocialAppTheme.coral, size: 32),
            ),
          ],
        ),
      ),
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
      height: 96,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _stories.length,
        separatorBuilder: (BuildContext context, int index) => const SizedBox(width: 14),
        itemBuilder: (BuildContext context, int index) {
          final story = _stories[index];
          return SizedBox(
            width: 72,
            child: Column(
              children: <Widget>[
                Transform.rotate(
                  angle: index.isEven ? -0.07 : 0.07,
                  child: Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: story.color,
                      border: Border.all(color: SocialAppTheme.ink, width: 2),
                      boxShadow: const <BoxShadow>[BoxShadow(color: SocialAppTheme.ink, offset: Offset(3, 3))],
                    ),
                    child: Center(
                      child: Text(
                        story.initials,
                        style: const TextStyle(color: SocialAppTheme.ink, fontSize: 12, fontWeight: FontWeight.w900),
                      ),
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
