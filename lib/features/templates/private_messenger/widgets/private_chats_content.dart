import 'package:flutter/material.dart';

import '../models/private_conversation.dart';
import '../private_messenger_theme.dart';
import 'private_conversation_tile.dart';

class PrivateChatsContent extends StatelessWidget {
  const PrivateChatsContent({required this.onOpenChat, super.key});

  final ValueChanged<PrivateConversation> onOpenChat;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 100),
      children: <Widget>[
        const _PrivateMessengerHeader(),
        const _StatusRail(),
        const SizedBox(height: 14),
        const _ChatFilters(),
        const SizedBox(height: 8),
        for (final conversation in PrivateConversation.samples)
          PrivateConversationTile(conversation: conversation, onTap: () => onOpenChat(conversation)),
      ],
    );
  }
}

class _PrivateMessengerHeader extends StatelessWidget {
  const _PrivateMessengerHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 18),
      child: Row(
        children: <Widget>[
          IconButton(
            tooltip: 'Back to template gallery',
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_rounded),
          ),
          const SizedBox(width: 4),
          const Expanded(
            child: Text(
              'Clover',
              style: TextStyle(
                fontFamily: PrivateMessengerTheme.displayFontName,
                fontSize: 34,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          IconButton(tooltip: 'Open camera', onPressed: () {}, icon: const Icon(Icons.camera_alt_outlined)),
          IconButton(tooltip: 'Search chats', onPressed: () {}, icon: const Icon(Icons.search_rounded)),
        ],
      ),
    );
  }
}

class _StatusRail extends StatelessWidget {
  const _StatusRail();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        scrollDirection: Axis.horizontal,
        children: const <Widget>[
          _StatusAvatar(
            label: 'My update',
            initials: 'ME',
            colors: <Color>[PrivateMessengerTheme.evergreen, PrivateMessengerTheme.mint],
            own: true,
          ),
          _StatusAvatar(label: 'Jules', initials: 'JU', colors: <Color>[Color(0xFFFFA070), Color(0xFFFFCE8A)]),
          _StatusAvatar(label: 'Nora', initials: 'NO', colors: <Color>[Color(0xFF68C99E), Color(0xFF279776)]),
          _StatusAvatar(label: 'Lea', initials: 'LE', colors: <Color>[Color(0xFFB78AF3), Color(0xFFE4C1FF)]),
          _StatusAvatar(label: 'Dad', initials: 'DA', colors: <Color>[Color(0xFF7797F7), Color(0xFFB9C7FF)]),
        ],
      ),
    );
  }
}

class _StatusAvatar extends StatelessWidget {
  const _StatusAvatar({required this.label, required this.initials, required this.colors, this.own = false});

  final String label;
  final String initials;
  final List<Color> colors;
  final bool own;

  @override
  Widget build(BuildContext context) {
    final colorsScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Column(
        children: <Widget>[
          Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: own ? colorsScheme.outlineVariant : colorsScheme.primary, width: 2),
                ),
                child: CircleAvatar(
                  radius: 27,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(colors: colors),
                    ),
                    child: SizedBox.expand(
                      child: Center(
                        child: Text(
                          initials,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (own)
                Positioned(
                  right: -1,
                  bottom: -1,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: colorsScheme.primary,
                    foregroundColor: colorsScheme.onPrimary,
                    child: const Icon(Icons.add_rounded, size: 15),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 5),
          Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _ChatFilters extends StatelessWidget {
  const _ChatFilters();

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: <Widget>[
          Chip(label: Text('All')),
          SizedBox(width: 8),
          Chip(label: Text('Unread  2')),
          SizedBox(width: 8),
          Chip(label: Text('Groups  2')),
        ],
      ),
    );
  }
}
