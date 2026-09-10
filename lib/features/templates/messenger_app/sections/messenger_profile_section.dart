import 'package:flutter/material.dart';

import '../messenger_app_theme.dart';
import '../models/conversation.dart';
import '../widgets/contact_avatar.dart';

class MessengerProfileSection extends StatefulWidget {
  const MessengerProfileSection({required this.scrollController, super.key});

  final ScrollController scrollController;

  @override
  State<MessengerProfileSection> createState() => _MessengerProfileSectionState();
}

class _MessengerProfileSectionState extends State<MessengerProfileSection> {
  var _readReceiptsAreEnabled = true;
  var _quietHoursAreEnabled = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const PageStorageKey<String>('messenger-profile'),
      controller: widget.scrollController,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
      children: <Widget>[
        const Text('Your space', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700)),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: <Color>[MessengerAppTheme.violet, MessengerAppTheme.primary]),
            borderRadius: BorderRadius.all(Radius.circular(28)),
            boxShadow: MessengerAppTheme.softShadow,
          ),
          child: const Row(
            children: <Widget>[
              ContactAvatar(initials: 'AR', tone: ConversationTone.gold, isOnline: true, radius: 30),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Alex Rivera',
                      style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 4),
                    Text('Available', style: TextStyle(color: Color(0xFFE7E2FF))),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        Material(
          color: MessengerAppTheme.surface,
          borderRadius: const BorderRadius.all(Radius.circular(24)),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: <Widget>[
              SwitchListTile.adaptive(
                secondary: const Icon(Icons.done_all_rounded, color: MessengerAppTheme.primary),
                title: const Text('Read receipts', style: TextStyle(fontWeight: FontWeight.w600)),
                value: _readReceiptsAreEnabled,
                onChanged: (bool value) {
                  setState(() {
                    _readReceiptsAreEnabled = value;
                  });
                },
              ),
              const Divider(height: 1, indent: 64, color: MessengerAppTheme.divider),
              SwitchListTile.adaptive(
                secondary: const Icon(Icons.bedtime_outlined, color: MessengerAppTheme.primary),
                title: const Text('Quiet hours', style: TextStyle(fontWeight: FontWeight.w600)),
                value: _quietHoursAreEnabled,
                onChanged: (bool value) {
                  setState(() {
                    _quietHoursAreEnabled = value;
                  });
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'All contacts and messages in this template are fictional local examples.',
          style: TextStyle(color: MessengerAppTheme.mutedInk, height: 1.4),
        ),
      ],
    );
  }
}
