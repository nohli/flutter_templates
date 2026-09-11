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
          border: Border.all(color: isSaved ? colors.primary : SocialAppTheme.ink, width: 2),
          boxShadow: SocialAppTheme.softShadow,
        ),
        child: Material(
          color: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 8, 10),
                child: Row(
                  children: <Widget>[
                    Transform.rotate(
                      angle: -0.08,
                      child: DecoratedBox(
                        decoration: const BoxDecoration(
                          color: SocialAppTheme.amber,
                          boxShadow: <BoxShadow>[BoxShadow(color: SocialAppTheme.ink, offset: Offset(2, 2))],
                        ),
                        child: SizedBox.square(
                          dimension: 40,
                          child: Center(
                            child: Text(
                              post.initials,
                              style: const TextStyle(
                                color: SocialAppTheme.ink,
                                fontSize: 11,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 11),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(post.author, style: const TextStyle(fontWeight: FontWeight.w900)),
                          const SizedBox(height: 2),
                          Text(
                            'FIELD NOTE / ${post.location.toUpperCase()}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: colors.onSurfaceVariant, fontSize: 8, letterSpacing: 0.6),
                          ),
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
              ClipPath(
                clipper: const _TornPaperClipper(),
                child: AspectRatio(aspectRatio: 1.55, child: SocialPostArt(artwork: post.artwork)),
              ),
              ColoredBox(
                color: SocialAppTheme.ink,
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
                          color: isLiked ? SocialAppTheme.coral : const Color(0xFFFFFBED),
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Comment on ${post.author}’s post',
                      onPressed: () => onPreviewAction('Comments are shown as an interface preview.'),
                      icon: const Icon(Icons.chat_bubble_outline_rounded, color: Color(0xFFFFFBED)),
                    ),
                    IconButton(
                      tooltip: 'Share ${post.author}’s post',
                      onPressed: () => onPreviewAction('Sharing is shown as an interface preview.'),
                      icon: const Icon(Icons.send_outlined, color: Color(0xFFFFFBED)),
                    ),
                    const Spacer(),
                    IconButton(
                      tooltip: isSaved ? 'Remove ${post.author}’s post from saved' : 'Save ${post.author}’s post',
                      onPressed: onToggleSaved,
                      icon: Icon(
                        isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                        color: SocialAppTheme.amber,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${post.likes + (isLiked ? 1 : 0)} appreciations',
                      style: TextStyle(
                        color: colors.primary,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(post.caption, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, height: 1.25)),
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

class _TornPaperClipper extends CustomClipper<Path> {
  const _TornPaperClipper();

  @override
  Path getClip(Size size) {
    const tooth = 8.0;
    final path = Path()..moveTo(0, tooth / 2);
    for (var x = 0.0; x < size.width; x += tooth) {
      path.lineTo(x + tooth / 2, x ~/ tooth % 2 == 0 ? 0 : tooth);
    }
    path
      ..lineTo(size.width, size.height - tooth / 2)
      ..lineTo(0, size.height - tooth / 2)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant _TornPaperClipper oldClipper) => false;
}
