import 'dart:async';

import 'package:flutter/material.dart';

import '../../../app/app_appearance.dart';
import '../shared/template_appearance.dart';
import '../shared/template_motion.dart';
import 'models/private_conversation.dart';
import 'private_chat_screen.dart';
import 'private_messenger_theme.dart';
import 'widgets/private_chats_content.dart';

class PrivateMessengerHomeScreen extends StatelessWidget {
  const PrivateMessengerHomeScreen({this.appearance = AppAppearance.light, super.key});

  final AppAppearance appearance;

  @override
  Widget build(BuildContext context) {
    return TemplateAppearanceShell(
      appearance: appearance,
      themeBuilder: PrivateMessengerTheme.build,
      builder: (BuildContext context) => const _PrivateMessengerHome(),
    );
  }
}

class _PrivateMessengerHome extends StatefulWidget {
  const _PrivateMessengerHome();

  @override
  State<_PrivateMessengerHome> createState() => _PrivateMessengerHomeState();
}

class _PrivateMessengerHomeState extends State<_PrivateMessengerHome> {
  var _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              tooltip: 'Start a private chat',
              onPressed: () {},
              child: const Icon(Icons.chat_rounded),
            )
          : null,
      body: SafeArea(
        bottom: false,
        child: TemplateEntrance(
          child: TemplateSectionSwitcher(
            selectedIndex: _selectedIndex,
            children: <Widget>[
              PrivateChatsContent(onOpenChat: _openChat),
              const _UpdatesContent(),
              const _CommunitiesContent(),
              const _CallsContent(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _PrivateNavigation(
        selectedIndex: _selectedIndex,
        onSelected: (int value) => setState(() => _selectedIndex = value),
      ),
    );
  }

  void _openChat(PrivateConversation conversation) {
    unawaited(
      Navigator.of(context).push<void>(
        templatePageRoute<void>(
          context: context,
          builder: (_) => PrivateChatScreen(conversation: conversation),
        ),
      ),
    );
  }
}

class _PrivateNavigation extends StatelessWidget {
  const _PrivateNavigation({required this.selectedIndex, required this.onSelected});

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    const items = <({String label, IconData icon})>[
      (label: 'Chats', icon: Icons.chat_bubble_rounded),
      (label: 'Updates', icon: Icons.blur_circular_rounded),
      (label: 'Communities', icon: Icons.groups_rounded),
      (label: 'Calls', icon: Icons.call_rounded),
    ];
    return SafeArea(
      top: false,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          border: Border(top: BorderSide(color: colors.outlineVariant)),
        ),
        child: SizedBox(
          height: 66,
          child: Row(
            children: <Widget>[
              for (var index = 0; index < items.length; index++)
                Expanded(
                  child: InkWell(
                    onTap: () => onSelected(index),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          items[index].icon,
                          color: selectedIndex == index ? colors.primary : colors.onSurfaceVariant,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          items[index].label,
                          style: TextStyle(
                            color: selectedIndex == index ? colors.primary : colors.onSurfaceVariant,
                            fontSize: 10,
                            fontWeight: selectedIndex == index ? FontWeight.w800 : FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UpdatesContent extends StatelessWidget {
  const _UpdatesContent();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 100),
      children: <Widget>[
        const _SectionTitle(title: 'Status updates', action: 'Privacy'),
        const SizedBox(height: 22),
        Container(
          height: 290,
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[PrivateMessengerTheme.evergreen, Color(0xFF3FB88F), PrivateMessengerTheme.mint],
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(40),
            ),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Text(
                      'JU',
                      style: TextStyle(color: PrivateMessengerTheme.evergreen, fontWeight: FontWeight.w800),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Jules · 12m',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              Spacer(),
              Text(
                'A slow evening\nin the greenhouse.',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: PrivateMessengerTheme.displayFontName,
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                  height: 1.05,
                ),
              ),
              SizedBox(height: 12),
              Text('Tap to reply', style: TextStyle(color: Colors.white70)),
            ],
          ),
        ),
        const SizedBox(height: 28),
        const _SectionTitle(title: 'Channels', action: 'Explore'),
        const ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 8),
          leading: CircleAvatar(backgroundColor: PrivateMessengerTheme.peach, child: Icon(Icons.palette_outlined)),
          title: Text('Weekend Makers', style: TextStyle(fontWeight: FontWeight.w800)),
          subtitle: Text('Three tiny creative challenges'),
        ),
      ],
    );
  }
}

class _CommunitiesContent extends StatelessWidget {
  const _CommunitiesContent();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 100),
      children: <Widget>[
        const _SectionTitle(title: 'Communities', action: 'New'),
        const SizedBox(height: 20),
        const _CommunityCard(
          icon: Icons.park_rounded,
          title: 'Neighbourhood Garden',
          detail: 'Announcements, volunteers, seed swap',
          color: PrivateMessengerTheme.mint,
        ),
        const SizedBox(height: 14),
        const _CommunityCard(
          icon: Icons.brush_rounded,
          title: 'Open Studio',
          detail: 'Critique, events, collaborations',
          color: PrivateMessengerTheme.lilac,
        ),
      ],
    );
  }
}

class _CallsContent extends StatelessWidget {
  const _CallsContent();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 100),
      children: <Widget>[
        const _SectionTitle(title: 'Calls', action: 'New link'),
        const SizedBox(height: 20),
        for (final call in const <({String name, String detail, Color color})>[
          (name: 'Sunday hikers', detail: 'Today, 14:20 · Group video', color: PrivateMessengerTheme.mint),
          (name: 'Dad', detail: 'Yesterday, 19:04 · 18 min', color: Color(0xFF9AB0F8)),
          (name: 'Lea', detail: 'Monday, 08:12 · Missed', color: PrivateMessengerTheme.lilac),
        ])
          ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 7),
            leading: CircleAvatar(
              backgroundColor: call.color,
              child: Text(
                call.name.characters.first,
                style: const TextStyle(color: Color(0xFF173129), fontWeight: FontWeight.w800),
              ),
            ),
            title: Text(call.name, style: const TextStyle(fontWeight: FontWeight.w800)),
            subtitle: Text(call.detail),
            trailing: const Icon(Icons.call_outlined),
          ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.action});

  final String title;
  final String action;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(title, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700)),
        ),
        TextButton(onPressed: () {}, child: Text(action)),
      ],
    );
  }
}

class _CommunityCard extends StatelessWidget {
  const _CommunityCard({required this.icon, required this.title, required this.detail, required this.color});

  final IconData icon;
  final String title;
  final String detail;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(7),
        ),
      ),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            radius: 26,
            backgroundColor: Colors.white70,
            child: Icon(icon, color: const Color(0xFF173129)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(color: Color(0xFF173129), fontSize: 17, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(detail, style: const TextStyle(color: Color(0xAA173129))),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: Color(0xFF173129)),
        ],
      ),
    );
  }
}
