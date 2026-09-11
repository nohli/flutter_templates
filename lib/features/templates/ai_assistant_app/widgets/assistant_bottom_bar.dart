import 'package:flutter/material.dart';

import '../ai_assistant_app_theme.dart';
import '../models/assistant_section.dart';

class AssistantBottomBar extends StatelessWidget {
  const AssistantBottomBar({required this.selectedSection, required this.onSelected, super.key});

  final AssistantSection selectedSection;
  final ValueChanged<AssistantSection> onSelected;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: AiAssistantAppTheme.surface,
          borderRadius: BorderRadius.all(Radius.circular(28)),
          border: Border.fromBorderSide(BorderSide(color: AiAssistantAppTheme.divider)),
          boxShadow: AiAssistantAppTheme.softShadow,
        ),
        child: NavigationBar(
          selectedIndex: selectedSection.index,
          onDestinationSelected: (int index) => onSelected(AssistantSection.values[index]),
          destinations: const <NavigationDestination>[
            NavigationDestination(icon: Icon(Icons.auto_awesome_rounded), label: 'Chat'),
            NavigationDestination(
              icon: Icon(Icons.explore_outlined),
              selectedIcon: Icon(Icons.explore),
              label: 'Discover',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline_rounded),
              selectedIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
