import 'package:flutter/material.dart';

import '../models/social_post.dart';
import '../social_feed_theme.dart';
import 'social_avatar.dart';

class SocialPostTile extends StatelessWidget {
  const SocialPostTile({
    required this.post,
    required this.liked,
    required this.reposted,
    required this.onLike,
    required this.onRepost,
    required this.onOpen,
    super.key,
  });

  final SocialPost post;
  final bool liked;
  final bool reposted;
  final VoidCallback onLike;
  final VoidCallback onRepost;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onOpen,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 14, 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SocialAvatar(initials: post.initials, colors: post.avatarColors),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          post.author,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Icon(Icons.verified_rounded, color: SocialFeedTheme.electricBlue, size: 16),
                      const SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          '${post.handle} · ${post.time}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: colors.onSurfaceVariant, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                  if (post.topic case final topic?) ...<Widget>[
                    const SizedBox(height: 6),
                    Text(
                      topic.toUpperCase(),
                      style: TextStyle(
                        color: colors.primary,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                  const SizedBox(height: 7),
                  Text(post.body, style: const TextStyle(fontSize: 16, height: 1.34)),
                  const SizedBox(height: 13),
                  _PostActions(post: post, liked: liked, reposted: reposted, onLike: onLike, onRepost: onRepost),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PostActions extends StatelessWidget {
  const _PostActions({
    required this.post,
    required this.liked,
    required this.reposted,
    required this.onLike,
    required this.onRepost,
  });

  final SocialPost post;
  final bool liked;
  final bool reposted;
  final VoidCallback onLike;
  final VoidCallback onRepost;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _PostAction(icon: Icons.chat_bubble_outline_rounded, label: '${post.replies}', color: muted),
        _PostAction(
          icon: Icons.repeat_rounded,
          label: '${post.reposts + (reposted ? 1 : 0)}',
          color: reposted ? const Color(0xFF20B781) : muted,
          onTap: onRepost,
          tooltip: reposted ? 'Undo repost' : 'Repost',
        ),
        _PostAction(
          icon: liked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          label: '${post.likes + (liked ? 1 : 0)}',
          color: liked ? SocialFeedTheme.accent : muted,
          onTap: onLike,
          tooltip: liked ? 'Unlike post' : 'Like post',
        ),
        _PostAction(icon: Icons.bookmark_border_rounded, label: '', color: muted),
      ],
    );
  }
}

class _PostAction extends StatelessWidget {
  const _PostAction({required this.icon, required this.label, required this.color, this.onTap, this.tooltip});

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: tooltip,
      button: onTap != null,
      child: InkResponse(
        onTap: onTap,
        radius: 22,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: <Widget>[
              Icon(icon, size: 18, color: color),
              if (label.isNotEmpty) ...<Widget>[
                const SizedBox(width: 5),
                Text(label, style: TextStyle(color: color, fontSize: 12)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
