import 'package:flutter/material.dart';

import '../models/social_post.dart';
import '../social_app_theme.dart';
import 'social_post_art.dart';

class SocialPostCard extends StatelessWidget {
  const SocialPostCard({
    required this.post,
    required this.isLiked,
    required this.isSaved,
    required this.onToggleLiked,
    required this.onToggleSaved,
    required this.onPreviewAction,
    super.key,
  });

  final SocialPost post;
  final bool isLiked;
  final bool isSaved;
  final VoidCallback onToggleLiked;
  final VoidCallback onToggleSaved;
  final ValueChanged<String> onPreviewAction;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Semantics(
      container: true,
      label: '${post.author}, ${post.caption}',
      child: AnimatedContainer(
        duration: MediaQuery.disableAnimationsOf(context) ? Duration.zero : const Duration(milliseconds: 240),
        curve: Curves.easeOutCubic,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: isSaved ? colors.primaryContainer.withValues(alpha: 0.55) : colors.surface,
          border: Border.all(color: isSaved ? colors.primary : Colors.transparent, width: 1.5),
          borderRadius: const BorderRadius.all(Radius.circular(28)),
          boxShadow: SocialAppTheme.softShadow,
        ),
        child: Material(
          color: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 10, 12),
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: SocialAppTheme.lavender,
                      child: Text(
                        post.initials,
                        style: const TextStyle(color: SocialAppTheme.ink, fontSize: 12, fontWeight: FontWeight.w800),
                      ),
                    ),
                    const SizedBox(width: 11),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(post.author, style: const TextStyle(fontWeight: FontWeight.w800)),
                          const SizedBox(height: 2),
                          Text(post.location, style: TextStyle(color: colors.onSurfaceVariant, fontSize: 12)),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'More options for ${post.author}',
                      onPressed: () => onPreviewAction('More options are shown as an interface preview.'),
                      icon: const Icon(Icons.more_horiz_rounded),
                    ),
                  ],
                ),
              ),
              AspectRatio(aspectRatio: 1.35, child: SocialPostArt(artwork: post.artwork)),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 2),
                child: Row(
                  children: <Widget>[
                    IconButton(
                      tooltip: isLiked ? 'Unlike ${post.author}’s post' : 'Like ${post.author}’s post',
                      onPressed: onToggleLiked,
                      icon: AnimatedSwitcher(
                        duration: MediaQuery.disableAnimationsOf(context)
                            ? Duration.zero
                            : const Duration(milliseconds: 180),
                        child: Icon(
                          isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          key: ValueKey<bool>(isLiked),
                          color: isLiked ? SocialAppTheme.coral : colors.onSurface,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Comment on ${post.author}’s post',
                      onPressed: () => onPreviewAction('Comments are shown as an interface preview.'),
                      icon: const Icon(Icons.chat_bubble_outline_rounded),
                    ),
                    IconButton(
                      tooltip: 'Share ${post.author}’s post',
                      onPressed: () => onPreviewAction('Sharing is shown as an interface preview.'),
                      icon: const Icon(Icons.send_outlined),
                    ),
                    const Spacer(),
                    IconButton(
                      tooltip: isSaved ? 'Remove ${post.author}’s post from saved' : 'Save ${post.author}’s post',
                      onPressed: onToggleSaved,
                      icon: Icon(isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${post.likes + (isLiked ? 1 : 0)} appreciations',
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 7),
                    Text(post.caption, style: const TextStyle(height: 1.35)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
