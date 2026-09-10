import 'package:flutter/material.dart';

import '../messenger_app_theme.dart';
import '../models/conversation.dart';
import '../widgets/contact_avatar.dart';

class MessengerPeopleSection extends StatelessWidget {
  const MessengerPeopleSection({required this.scrollController, required this.onConversationSelected, super.key});

  final ScrollController scrollController;
  final ValueChanged<Conversation> onConversationSelected;

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const PageStorageKey<String>('messenger-people'),
      controller: scrollController,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
      children: <Widget>[
        const Text('People', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        const Text(
          'A reusable contact directory with presence cues.',
          style: TextStyle(color: MessengerAppTheme.mutedInk),
        ),
        const SizedBox(height: 20),
        Material(
          color: MessengerAppTheme.surface,
          elevation: 2,
          shadowColor: const Color(0x24201D2D),
          borderRadius: const BorderRadius.all(Radius.circular(26)),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: <Widget>[
              for (final conversation in Conversation.samples) ...<Widget>[
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  leading: ContactAvatar(
                    initials: conversation.initials,
                    tone: conversation.tone,
                    isOnline: conversation.isOnline,
                    radius: 22,
                  ),
                  title: Text(conversation.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                  subtitle: Text(conversation.isOnline ? 'Online now' : 'Away'),
                  trailing: const Icon(Icons.chat_bubble_outline_rounded),
                  onTap: () => onConversationSelected(conversation),
                ),
                if (conversation != Conversation.samples.last)
                  const Padding(
                    padding: EdgeInsets.only(left: 74),
                    child: Divider(height: 1, color: MessengerAppTheme.divider),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
