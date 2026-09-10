import 'package:flutter/material.dart';

import '../models/podcast_section.dart';
import '../podcast_app_theme.dart';

class PodcastBottomBar extends StatelessWidget {
  const PodcastBottomBar({required this.selectedSection, required this.onSelected, super.key});

  final PodcastSection selectedSection;
  final ValueChanged<PodcastSection> onSelected;

  @override
  Widget build(BuildContext context) {
    final usesLargeText = MediaQuery.textScalerOf(context).scale(1) >= 2;

    return ColoredBox(
      color: PodcastAppTheme.background,
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.fromLTRB(16, 6, 16, 12),
        child: Material(
          color: PodcastAppTheme.surface,
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
      indicatorColor: PodcastAppTheme.blush,
      onDestinationSelected: (int index) => onSelected(PodcastSection.values[index]),
      destinations: const <NavigationDestination>[
        NavigationDestination(
          icon: Icon(Icons.explore_outlined),
          selectedIcon: Icon(Icons.explore_rounded),
          label: 'Discover',
        ),
        NavigationDestination(
          icon: Icon(Icons.bookmarks_outlined),
          selectedIcon: Icon(Icons.bookmarks_rounded),
          label: 'Library',
        ),
        NavigationDestination(
          icon: Icon(Icons.graphic_eq_rounded),
          selectedIcon: Icon(Icons.equalizer_rounded),
          label: 'Player',
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
          for (final section in PodcastSection.values) ...<Widget>[
            _LargeDestination(
              label: _labelFor(section),
              icon: _iconFor(section),
              isSelected: section == selectedSection,
              onPressed: () => onSelected(section),
            ),
            if (section != PodcastSection.values.last) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }

  String _labelFor(PodcastSection section) => switch (section) {
    PodcastSection.discover => 'Discover',
    PodcastSection.library => 'Library',
    PodcastSection.player => 'Player',
  };

  IconData _iconFor(PodcastSection section) => switch (section) {
    PodcastSection.discover => Icons.explore_rounded,
    PodcastSection.library => Icons.bookmarks_rounded,
    PodcastSection.player => Icons.equalizer_rounded,
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
