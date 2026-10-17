import 'dart:async';

import 'package:flutter/material.dart';

import '../../../app/app_appearance.dart';
import '../shared/template_appearance.dart';
import '../shared/template_motion.dart';
import 'models/private_conversation.dart';
import 'private_chat_screen.dart';
import 'private_messenger_theme.dart';
import 'widgets/private_chats_content.dart';
import '../../../l10n/localizations.dart';

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
              tooltip: context.l10n.startAPrivateChat,
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
          builder: (context) => PrivateChatScreen(
            conversation: PrivateConversation.samples(
              context.l10n,
            ).firstWhere((sample) => sample.initials == conversation.initials),
          ),
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
    final items = <({String label, IconData icon})>[
      (label: context.l10n.chats, icon: Icons.chat_bubble_rounded),
      (label: context.l10n.updates, icon: Icons.blur_circular_rounded),
      (label: context.l10n.communities, icon: Icons.groups_rounded),
      (label: context.l10n.calls, icon: Icons.call_rounded),
    ];
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Container(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: const BorderRadius.all(Radius.circular(28)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: colors.shadow.withValues(alpha: 0.18),
                blurRadius: 24,
                spreadRadius: -7,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(28)),
            child: Material(
              color: Colors.transparent,
              child: SizedBox(
                height: 68,
                child: Row(
                  children: <Widget>[
                    for (var index = 0; index < items.length; index++)
                      _PrivateNavigationItem(
                        label: items[index].label,
                        icon: items[index].icon,
                        selected: selectedIndex == index,
                        onTap: () => onSelected(index),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PrivateNavigationItem extends StatelessWidget {
  const _PrivateNavigationItem({required this.label, required this.icon, required this.selected, required this.onTap});

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Expanded(
      child: Semantics(
        label: label,
        selected: selected,
        button: true,
        onTap: onTap,
        excludeSemantics: true,
        child: InkWell(
          onTap: onTap,
          borderRadius: const BorderRadius.all(Radius.circular(22)),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: selected ? colors.primary : Colors.transparent,
              borderRadius: const BorderRadius.all(Radius.circular(22)),
              boxShadow: selected
                  ? <BoxShadow>[
                      BoxShadow(
                        color: colors.primary.withValues(alpha: 0.28),
                        blurRadius: 14,
                        offset: const Offset(0, 5),
                      ),
                    ]
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                AnimatedScale(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutBack,
                  scale: selected ? 1.08 : 1,
                  child: Icon(icon, size: 21, color: selected ? colors.onPrimary : colors.onSurfaceVariant),
                ),
                const SizedBox(height: 3),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 180),
                  style: TextStyle(
                    color: selected ? colors.onPrimary : colors.onSurfaceVariant,
                    fontFamily: PrivateMessengerTheme.fontName,
                    fontSize: 10.5,
                    fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                  ),
                  child: Text(label, maxLines: 1, overflow: TextOverflow.fade, softWrap: false),
                ),
              ],
            ),
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
        _SectionTitle(title: context.l10n.statusUpdates, action: context.l10n.privacy),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Text(
                      'JU',
                      style: TextStyle(color: PrivateMessengerTheme.evergreen, fontWeight: FontWeight.w800),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    context.l10n.jules12M,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                context.l10n.aSlowEveningInTheGreenhouse,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: PrivateMessengerTheme.displayFontName,
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                  height: 1.05,
                ),
              ),
              const SizedBox(height: 12),
              Text(context.l10n.tapToReply, style: const TextStyle(color: Colors.white70)),
            ],
          ),
        ),
        const SizedBox(height: 28),
        _SectionTitle(title: context.l10n.channels, action: context.l10n.explore),
        ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          leading: const CircleAvatar(
            backgroundColor: PrivateMessengerTheme.peach,
            child: Icon(Icons.palette_outlined),
          ),
          title: Text(context.l10n.weekendMakers, style: const TextStyle(fontWeight: FontWeight.w800)),
          subtitle: Text(context.l10n.threeTinyCreativeChallenges),
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
        _SectionTitle(title: context.l10n.communities, action: context.l10n.newAction),
        const SizedBox(height: 20),
        _CommunityCard(
          icon: Icons.park_rounded,
          title: context.l10n.neighbourhoodGarden,
          detail: context.l10n.announcementsVolunteersSeedSwap,
          color: PrivateMessengerTheme.mint,
        ),
        const SizedBox(height: 14),
        _CommunityCard(
          icon: Icons.brush_rounded,
          title: context.l10n.openStudio,
          detail: context.l10n.critiqueEventsCollaborations,
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
        _SectionTitle(title: context.l10n.calls, action: context.l10n.newLink),
        const SizedBox(height: 20),
        for (final call in <({String name, String detail, Color color})>[
          (
            name: context.l10n.sundayHikers,
            detail: context.l10n.today1420GroupVideo,
            color: PrivateMessengerTheme.mint,
          ),
          (name: context.l10n.dad, detail: context.l10n.yesterday190418Min, color: const Color(0xFF9AB0F8)),
          (name: 'Lea', detail: context.l10n.monday0812Missed, color: PrivateMessengerTheme.lilac),
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
