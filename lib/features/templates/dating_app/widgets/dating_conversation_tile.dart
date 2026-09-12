import 'package:flutter/material.dart';

import '../dating_app_theme.dart';
import '../models/dating_conversation.dart';
import 'dating_conversation_avatar.dart';

class DatingConversationTile extends StatelessWidget {
  const DatingConversationTile({required this.conversation, required this.onTap, super.key});

  final DatingConversation conversation;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final hasUnread = conversation.unreadCount > 0;

    return Semantics(
      button: true,
      excludeSemantics: true,
      label: 'Open conversation with ${conversation.name}',
      child: Material(
        color: hasUnread ? colors.primaryContainer.withValues(alpha: 0.55) : colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: DatingAppTheme.controlRadius,
          side: BorderSide(color: hasUnread ? colors.primary : colors.outlineVariant),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 13, 12, 13),
            child: Row(
              children: <Widget>[
                DatingConversationAvatar(conversation: conversation),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              conversation.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: DatingAppTheme.displayFontName,
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Text(
                            conversation.latestMessage.time,
                            style: TextStyle(
                              color: hasUnread ? colors.primary : colors.onSurfaceVariant,
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.6,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              conversation.latestMessage.text,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: colors.onSurfaceVariant,
                                height: 1.25,
                                fontWeight: hasUnread ? FontWeight.w700 : FontWeight.w400,
                              ),
                            ),
                          ),
                          if (hasUnread) ...<Widget>[
                            const SizedBox(width: 10),
                            Container(
                              constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                              padding: const EdgeInsets.symmetric(horizontal: 7),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(color: colors.primary, shape: BoxShape.circle),
                              child: Text(
                                '${conversation.unreadCount}',
                                style: TextStyle(color: colors.onPrimary, fontSize: 11, fontWeight: FontWeight.w900),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.chevron_right_rounded, color: colors.onSurfaceVariant),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
