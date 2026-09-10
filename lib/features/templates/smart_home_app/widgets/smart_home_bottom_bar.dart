import 'package:flutter/material.dart';

import '../models/smart_home_section.dart';
import '../smart_home_app_theme.dart';

class SmartHomeBottomBar extends StatelessWidget {
  const SmartHomeBottomBar({required this.selectedSection, required this.onSelected, super.key});

  final SmartHomeSection selectedSection;
  final ValueChanged<SmartHomeSection> onSelected;

  @override
  Widget build(BuildContext context) {
    final usesLargeText = MediaQuery.textScalerOf(context).scale(1) >= 2;

    return ColoredBox(
      color: SmartHomeAppTheme.background,
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.fromLTRB(16, 6, 16, 12),
        child: Material(
          color: SmartHomeAppTheme.surface,
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
      indicatorColor: SmartHomeAppTheme.mint,
      onDestinationSelected: (int index) => onSelected(SmartHomeSection.values[index]),
      destinations: const <NavigationDestination>[
        NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded), label: 'Home'),
        NavigationDestination(
          icon: Icon(Icons.meeting_room_outlined),
          selectedIcon: Icon(Icons.meeting_room_rounded),
          label: 'Rooms',
        ),
        NavigationDestination(icon: Icon(Icons.bolt_outlined), selectedIcon: Icon(Icons.bolt_rounded), label: 'Energy'),
      ],
    );
  }

  Widget _largeTextNavigation() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          for (final section in SmartHomeSection.values) ...<Widget>[
            _LargeDestination(
              label: _labelFor(section),
              icon: _iconFor(section),
              isSelected: section == selectedSection,
              onPressed: () => onSelected(section),
            ),
            if (section != SmartHomeSection.values.last) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }

  String _labelFor(SmartHomeSection section) => switch (section) {
    SmartHomeSection.home => 'Home',
    SmartHomeSection.rooms => 'Rooms',
    SmartHomeSection.energy => 'Energy',
  };

  IconData _iconFor(SmartHomeSection section) => switch (section) {
    SmartHomeSection.home => Icons.home_rounded,
    SmartHomeSection.rooms => Icons.meeting_room_rounded,
    SmartHomeSection.energy => Icons.bolt_rounded,
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
