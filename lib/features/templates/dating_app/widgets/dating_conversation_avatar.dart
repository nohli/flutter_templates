import 'package:flutter/material.dart';

import '../dating_app_theme.dart';
import '../models/dating_conversation.dart';
import 'dating_profile_artwork.dart';

class DatingConversationAvatar extends StatelessWidget {
  const DatingConversationAvatar({required this.conversation, this.size = 54, super.key});

  final DatingConversation conversation;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: true,
      label: '${conversation.name} profile portrait${conversation.isOnline ? ', online' : ''}',
      child: SizedBox.square(
        dimension: size,
        child: Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            Positioned.fill(
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: DatingAppTheme.mint, width: 2),
                ),
                child: DatingProfileArtwork(palette: conversation.palette),
              ),
            ),
            if (conversation.isOnline)
              Positioned(
                right: 0,
                bottom: 1,
                child: Container(
                  width: 13,
                  height: 13,
                  decoration: BoxDecoration(
                    color: DatingAppTheme.mint,
                    shape: BoxShape.circle,
                    border: Border.all(color: Theme.of(context).colorScheme.surface, width: 2),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
