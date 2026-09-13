import 'package:flutter/material.dart';

import '../models/channel_conversation.dart';

class ChannelConversationTile extends StatelessWidget {
  const ChannelConversationTile({required this.conversation, required this.onTap, super.key});

  final ChannelConversation conversation;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Semantics(
      label: 'Open ${conversation.title}',
      button: true,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(17, 11, 17, 11),
          child: Row(
            children: <Widget>[
              _ChannelAvatar(conversation: conversation),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        if (conversation.pinned) ...<Widget>[
                          Icon(Icons.push_pin_rounded, size: 13, color: colors.onSurfaceVariant),
                          const SizedBox(width: 4),
                        ],
                        Expanded(
                          child: Text(
                            conversation.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                          ),
                        ),
                        Text(
                          conversation.time,
                          style: TextStyle(
                            color: conversation.unread > 0 ? colors.primary : colors.onSurfaceVariant,
                            fontSize: 12,
                            fontWeight: conversation.unread > 0 ? FontWeight.w700 : FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            conversation.preview,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: colors.onSurfaceVariant, height: 1.2),
                          ),
                        ),
                        if (conversation.muted)
                          Icon(Icons.notifications_off_outlined, size: 15, color: colors.onSurfaceVariant),
                        if (conversation.unread > 0) ...<Widget>[
                          const SizedBox(width: 8),
                          Container(
                            height: 23,
                            constraints: const BoxConstraints(minWidth: 23),
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            decoration: BoxDecoration(
                              color: colors.primary,
                              borderRadius: const BorderRadius.all(Radius.circular(12)),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${conversation.unread}',
                              style: TextStyle(color: colors.onPrimary, fontSize: 11, fontWeight: FontWeight.w800),
                            ),
                          ),
                        ],
                      ],
                    ),
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

class _ChannelAvatar extends StatelessWidget {
  const _ChannelAvatar({required this.conversation});

  final ChannelConversation conversation;

  @override
  Widget build(BuildContext context) {
    final badge = switch (conversation.kind) {
      ChannelConversationKind.private => null,
      ChannelConversationKind.group => Icons.groups_rounded,
      ChannelConversationKind.channel => Icons.campaign_rounded,
    };
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        CircleAvatar(
          radius: 28,
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: conversation.colors),
            ),
            child: SizedBox.expand(
              child: Center(
                child: Text(
                  conversation.initials,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ),
        ),
        if (badge != null)
          Positioned(
            right: -2,
            bottom: -2,
            child: CircleAvatar(
              radius: 10,
              backgroundColor: Theme.of(context).colorScheme.surface,
              child: Icon(badge, size: 13, color: Theme.of(context).colorScheme.primary),
            ),
          ),
      ],
    );
  }
}
