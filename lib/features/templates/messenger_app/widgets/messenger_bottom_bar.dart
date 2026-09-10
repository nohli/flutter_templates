import 'package:flutter/material.dart';

import '../messenger_app_theme.dart';
import '../models/messenger_section.dart';

class MessengerBottomBar extends StatelessWidget {
  const MessengerBottomBar({required this.selectedSection, required this.onSelected, super.key});

  final MessengerSection selectedSection;
  final ValueChanged<MessengerSection> onSelected;

  @override
  Widget build(BuildContext context) {
    final usesLargeText = MediaQuery.textScalerOf(context).scale(1) >= 2;

    return ColoredBox(
      color: MessengerAppTheme.background,
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.fromLTRB(16, 6, 16, 12),
        child: Material(
          color: MessengerAppTheme.surface,
          borderRadius: const BorderRadius.all(Radius.circular(24)),
          clipBehavior: Clip.antiAlias,
          child: usesLargeText ? _largeTextNavigation() : _standardNavigation(),
        ),
      ),
    );
  }

  Widget _standardNavigation() {
    return NavigationBar(
      height: 68,
      selectedIndex: selectedSection.index,
      backgroundColor: Colors.transparent,
      indicatorColor: MessengerAppTheme.lavender,
      onDestinationSelected: (int index) => onSelected(MessengerSection.values[index]),
      destinations: const <NavigationDestination>[
        NavigationDestination(
          icon: Icon(Icons.chat_bubble_outline_rounded),
          selectedIcon: Icon(Icons.chat_bubble_rounded),
          label: 'Chats',
        ),
        NavigationDestination(
          icon: Icon(Icons.people_outline_rounded),
          selectedIcon: Icon(Icons.people_rounded),
          label: 'People',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline_rounded),
          selectedIcon: Icon(Icons.person_rounded),
          label: 'Profile',
        ),
      ],
    );
  }

  Widget _largeTextNavigation() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          for (final section in MessengerSection.values) ...<Widget>[
            _LargeDestination(
              label: _labelFor(section),
              icon: _iconFor(section),
              isSelected: selectedSection == section,
              onPressed: () => onSelected(section),
            ),
            if (section != MessengerSection.values.last) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }

  String _labelFor(MessengerSection section) => switch (section) {
    MessengerSection.chats => 'Chats',
    MessengerSection.people => 'People',
    MessengerSection.profile => 'Profile',
  };

  IconData _iconFor(MessengerSection section) => switch (section) {
    MessengerSection.chats => Icons.chat_bubble_rounded,
    MessengerSection.people => Icons.people_rounded,
    MessengerSection.profile => Icons.person_rounded,
  };
}

class _LargeDestination extends StatelessWidget {
  const _LargeDestination({required this.label, required this.icon, required this.isSelected, required this.onPressed});

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final iconWidget = Icon(icon);
    final labelWidget = Text(label);

    return isSelected
        ? FilledButton.tonalIcon(onPressed: onPressed, icon: iconWidget, label: labelWidget)
        : TextButton.icon(onPressed: onPressed, icon: iconWidget, label: labelWidget);
  }
}
