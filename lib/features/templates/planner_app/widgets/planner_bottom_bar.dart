import 'package:flutter/material.dart';

import '../models/planner_section.dart';
import '../planner_app_theme.dart';

class PlannerBottomBar extends StatelessWidget {
  const PlannerBottomBar({required this.selectedSection, required this.onSelected, super.key});

  final PlannerSection selectedSection;
  final ValueChanged<PlannerSection> onSelected;

  @override
  Widget build(BuildContext context) {
    final usesLargeText = MediaQuery.textScalerOf(context).scale(1) >= 2;

    return ColoredBox(
      color: PlannerAppTheme.background,
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.fromLTRB(16, 6, 16, 12),
        child: Material(
          color: PlannerAppTheme.surface,
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
      indicatorColor: PlannerAppTheme.lime,
      onDestinationSelected: (int index) => onSelected(PlannerSection.values[index]),
      destinations: const <NavigationDestination>[
        NavigationDestination(
          icon: Icon(Icons.today_outlined),
          selectedIcon: Icon(Icons.today_rounded),
          label: 'Today',
        ),
        NavigationDestination(
          icon: Icon(Icons.dashboard_outlined),
          selectedIcon: Icon(Icons.dashboard_rounded),
          label: 'Projects',
        ),
        NavigationDestination(
          icon: Icon(Icons.center_focus_weak_outlined),
          selectedIcon: Icon(Icons.center_focus_strong_rounded),
          label: 'Focus',
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
          for (final section in PlannerSection.values) ...<Widget>[
            _LargeDestination(
              label: _labelFor(section),
              icon: _iconFor(section),
              isSelected: selectedSection == section,
              onPressed: () => onSelected(section),
            ),
            if (section != PlannerSection.values.last) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }

  String _labelFor(PlannerSection section) => switch (section) {
    PlannerSection.today => 'Today',
    PlannerSection.projects => 'Projects',
    PlannerSection.focus => 'Focus',
  };

  IconData _iconFor(PlannerSection section) => switch (section) {
    PlannerSection.today => Icons.today_rounded,
    PlannerSection.projects => Icons.dashboard_rounded,
    PlannerSection.focus => Icons.center_focus_strong_rounded,
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
