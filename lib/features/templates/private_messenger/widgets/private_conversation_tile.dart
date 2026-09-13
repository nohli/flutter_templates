import 'package:flutter/material.dart';

import '../models/private_conversation.dart';

class PrivateConversationTile extends StatelessWidget {
  const PrivateConversationTile({required this.conversation, required this.onTap, super.key});

  final PrivateConversation conversation;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Semantics(
      label: 'Open private chat with ${conversation.name}',
      button: true,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: Row(
            children: <Widget>[
              _PrivateAvatar(conversation: conversation),
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
                        if (conversation.sent) ...<Widget>[
                          Icon(Icons.done_all_rounded, size: 17, color: colors.primary),
                          const SizedBox(width: 4),
                        ],
                        Expanded(
                          child: Text(
                            conversation.preview,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: colors.onSurfaceVariant),
                          ),
                        ),
                        if (conversation.unread > 0)
                          Container(
                            height: 22,
                            constraints: const BoxConstraints(minWidth: 22),
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

class _PrivateAvatar extends StatelessWidget {
  const _PrivateAvatar({required this.conversation});

  final PrivateConversation conversation;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        CircleAvatar(
          radius: 27,
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
        if (conversation.group)
          Positioned(
            right: -3,
            bottom: -3,
            child: CircleAvatar(
              radius: 10,
              backgroundColor: Theme.of(context).colorScheme.surface,
              child: Icon(Icons.groups_rounded, size: 13, color: Theme.of(context).colorScheme.primary),
            ),
          ),
      ],
    );
  }
}
