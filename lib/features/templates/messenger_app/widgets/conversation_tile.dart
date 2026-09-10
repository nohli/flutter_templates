import 'package:flutter/material.dart';

import '../messenger_app_theme.dart';
import '../models/conversation.dart';
import 'contact_avatar.dart';

class ConversationTile extends StatelessWidget {
  const ConversationTile({required this.conversation, required this.onTap, super.key});

  final Conversation conversation;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Open conversation with ${conversation.name}, ${conversation.preview}',
      onTap: onTap,
      child: Material(
        color: MessengerAppTheme.surface,
        borderRadius: const BorderRadius.all(Radius.circular(22)),
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(22)),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: <Widget>[
                ContactAvatar(
                  initials: conversation.initials,
                  tone: conversation.tone,
                  isOnline: conversation.isOnline,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(conversation.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text(
                        conversation.preview,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: MessengerAppTheme.mutedInk, fontSize: 12, height: 1.3),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      conversation.timeLabel,
                      style: const TextStyle(color: MessengerAppTheme.mutedInk, fontSize: 11),
                    ),
                    const SizedBox(height: 8),
                    if (conversation.unreadCount > 0)
                      Badge(label: Text('${conversation.unreadCount}'), backgroundColor: MessengerAppTheme.primary),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
