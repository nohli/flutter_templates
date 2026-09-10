import 'package:flutter/material.dart';

import '../messenger_app_theme.dart';
import '../models/conversation.dart';
import '../widgets/contact_avatar.dart';
import '../widgets/conversation_tile.dart';

class MessengerChatsSection extends StatelessWidget {
  const MessengerChatsSection({
    required this.conversations,
    required this.scrollController,
    required this.onQueryChanged,
    required this.onConversationSelected,
    super.key,
  });

  final List<Conversation> conversations;
  final ScrollController scrollController;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<Conversation> onConversationSelected;

  @override
  Widget build(BuildContext context) {
    final online = Conversation.samples.where((Conversation conversation) => conversation.isOnline).toList();

    return ListView(
      key: const PageStorageKey<String>('messenger-chats'),
      controller: scrollController,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
      children: <Widget>[
        const Text('Messages that feel close.', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700)),
        const SizedBox(height: 18),
        TextField(
          onChanged: onQueryChanged,
          decoration: const InputDecoration(
            hintText: 'Search conversations',
            prefixIcon: Icon(Icons.search_rounded),
            filled: true,
            fillColor: MessengerAppTheme.surface,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(18)),
            ),
          ),
        ),
        const SizedBox(height: 22),
        const Text('Online now', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              for (final conversation in online) ...<Widget>[
                _OnlineContact(conversation: conversation, onTap: () => onConversationSelected(conversation)),
                if (conversation != online.last) const SizedBox(width: 16),
              ],
            ],
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: <Widget>[
            const Expanded(
              child: Text('Recent', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            ),
            Text('${conversations.length} chats', style: const TextStyle(color: MessengerAppTheme.mutedInk)),
          ],
        ),
        const SizedBox(height: 12),
        if (conversations.isEmpty)
          const _EmptyConversationState()
        else
          for (final conversation in conversations) ...<Widget>[
            ConversationTile(conversation: conversation, onTap: () => onConversationSelected(conversation)),
            if (conversation != conversations.last) const SizedBox(height: 10),
          ],
      ],
    );
  }
}

class _OnlineContact extends StatelessWidget {
  const _OnlineContact({required this.conversation, required this.onTap});

  final Conversation conversation;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          children: <Widget>[
            ContactAvatar(initials: conversation.initials, tone: conversation.tone, isOnline: true, radius: 28),
            const SizedBox(height: 6),
            SizedBox(
              width: 68,
              child: Text(
                conversation.name.split(' ').first,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyConversationState extends StatelessWidget {
  const _EmptyConversationState();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
      decoration: const BoxDecoration(
        color: MessengerAppTheme.surface,
        borderRadius: BorderRadius.all(Radius.circular(24)),
      ),
      child: const Column(
        children: <Widget>[
          Icon(Icons.forum_outlined, size: 40, color: MessengerAppTheme.primary),
          SizedBox(height: 12),
          Text('No conversations found', style: TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
