import 'package:flutter/material.dart';

import '../messenger_app_theme.dart';
import '../models/conversation.dart';

class ContactAvatar extends StatelessWidget {
  const ContactAvatar({required this.initials, required this.tone, this.isOnline = false, this.radius = 25, super.key});

  final String initials;
  final ConversationTone tone;
  final bool isOnline;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: true,
      label: '$initials avatar${isOnline ? ', online' : ''}',
      child: SizedBox.square(
        dimension: radius * 2 + 4,
        child: Stack(
          children: <Widget>[
            CircleAvatar(
              radius: radius,
              backgroundColor: _colorFor(tone),
              child: Text(
                initials,
                style: TextStyle(color: MessengerAppTheme.ink, fontSize: radius * 0.48, fontWeight: FontWeight.w700),
              ),
            ),
            if (isOnline)
              Positioned(
                right: 1,
                bottom: 1,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: const BoxDecoration(
                    color: Color(0xFF3DAE7D),
                    shape: BoxShape.circle,
                    border: Border.fromBorderSide(BorderSide(color: Colors.white, width: 2)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _colorFor(ConversationTone tone) => switch (tone) {
    ConversationTone.aqua => MessengerAppTheme.aqua,
    ConversationTone.lavender => MessengerAppTheme.lavender,
    ConversationTone.rose => MessengerAppTheme.rose,
    ConversationTone.gold => MessengerAppTheme.gold,
  };
}
