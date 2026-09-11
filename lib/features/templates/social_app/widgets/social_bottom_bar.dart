import 'package:flutter/material.dart';

import '../models/social_section.dart';
import '../social_app_theme.dart';

class SocialBottomBar extends StatelessWidget {
  const SocialBottomBar({required this.selectedSection, required this.onSelected, super.key});

  final SocialSection selectedSection;
  final ValueChanged<SocialSection> onSelected;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: SocialAppTheme.surface,
          borderRadius: BorderRadius.all(Radius.circular(28)),
          boxShadow: SocialAppTheme.softShadow,
        ),
        child: NavigationBar(
          selectedIndex: selectedSection.index,
          onDestinationSelected: (int index) => onSelected(SocialSection.values[index]),
          destinations: const <NavigationDestination>[
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded),
              label: 'Feed',
            ),
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
