import 'package:flutter/material.dart';

import '../ai_assistant_app_theme.dart';
import '../models/assistant_section.dart';

class AssistantNavigationDrawer extends StatelessWidget {
  const AssistantNavigationDrawer({
    required this.selectedSection,
    required this.onSelected,
    required this.onNewChat,
    super.key,
  });

  final AssistantSection selectedSection;
  final ValueChanged<AssistantSection> onSelected;
  final VoidCallback onNewChat;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AiAssistantAppTheme.background,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.horizontal(left: Radius.circular(32))),
      child: SafeArea(
        child: ListView(
          primary: false,
          padding: const EdgeInsets.fromLTRB(12, 18, 12, 20),
          children: <Widget>[
            const _WorkspaceHeader(),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                onNewChat();
              },
              icon: const Icon(Icons.add_rounded),
              label: const Text('New conversation'),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: AiAssistantAppTheme.aqua,
                foregroundColor: AiAssistantAppTheme.background,
                shape: const RoundedRectangleBorder(borderRadius: AiAssistantAppTheme.controlRadius),
              ),
            ),
            const SizedBox(height: 18),
            for (final section in AssistantSection.values)
              ListTile(
                selected: selectedSection == section,
                selectedTileColor: AiAssistantAppTheme.primary,
                iconColor: AiAssistantAppTheme.aqua,
                textColor: AiAssistantAppTheme.ink,
                selectedColor: AiAssistantAppTheme.background,
                shape: const RoundedRectangleBorder(borderRadius: AiAssistantAppTheme.controlRadius),
                leading: Icon(_iconFor(section)),
                title: Text(_labelFor(section), style: const TextStyle(fontWeight: FontWeight.w800)),
                onTap: () {
                  Navigator.of(context).pop();
                  onSelected(section);
                },
              ),
            const Padding(
              padding: EdgeInsets.fromLTRB(12, 22, 12, 10),
              child: Text(
                'RECENT',
                style: TextStyle(
                  color: AiAssistantAppTheme.mutedInk,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            _RecentConversation(
              icon: Icons.rocket_launch_outlined,
              title: 'Launch brief',
              onTap: () => _openRecent(context),
            ),
            _RecentConversation(
              icon: Icons.account_tree_outlined,
              title: 'App architecture',
              onTap: () => _openRecent(context),
            ),
            _RecentConversation(
              icon: Icons.edit_note_rounded,
              title: 'Rewrite the opening',
              onTap: () => _openRecent(context),
            ),
          ],
        ),
      ),
    );
  }

  String _labelFor(AssistantSection section) => switch (section) {
    AssistantSection.chat => 'Chat',
    AssistantSection.discover => 'Assistants',
    AssistantSection.profile => 'Profile',
  };

  IconData _iconFor(AssistantSection section) => switch (section) {
    AssistantSection.chat => Icons.auto_awesome_rounded,
    AssistantSection.discover => Icons.grid_view_rounded,
    AssistantSection.profile => Icons.person_outline_rounded,
  };

  void _openRecent(BuildContext context) {
    Navigator.of(context).pop();
    onSelected(AssistantSection.chat);
  }
}

class _WorkspaceHeader extends StatelessWidget {
  const _WorkspaceHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: <Widget>[
          Container(
            width: 46,
            height: 46,
            decoration: const BoxDecoration(
              color: AiAssistantAppTheme.primary,
              shape: BoxShape.circle,
              border: Border.fromBorderSide(BorderSide(color: AiAssistantAppTheme.aqua)),
            ),
            child: const Icon(Icons.auto_awesome_rounded, color: AiAssistantAppTheme.background),
          ),
          const SizedBox(width: 13),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'NOVA / SPATIAL OS',
                  style: TextStyle(color: AiAssistantAppTheme.ink, fontSize: 15, fontWeight: FontWeight.w900),
                ),
                Text('Private workspace', style: TextStyle(color: AiAssistantAppTheme.mutedInk, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentConversation extends StatelessWidget {
  const _RecentConversation({required this.icon, required this.title, required this.onTap});

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      iconColor: AiAssistantAppTheme.aqua,
      textColor: AiAssistantAppTheme.ink,
      leading: Icon(icon, size: 20),
      title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
      onTap: onTap,
    );
  }
}
