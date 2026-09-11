import 'package:flutter/material.dart';

import '../models/planner_section.dart';

class PlannerDayRail extends StatelessWidget {
  const PlannerDayRail({required this.selectedSection, required this.onSelected, super.key});

  final PlannerSection selectedSection;
  final ValueChanged<PlannerSection> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final hideLabels = MediaQuery.textScalerOf(context).scale(1) >= 1.8;

    return SizedBox(
      width: 76,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          border: Border(right: BorderSide(color: colors.outlineVariant)),
        ),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 14),
            const _DateStamp(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 15),
              child: Divider(height: 1, color: colors.outlineVariant),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                children: <Widget>[
                  for (final section in PlannerSection.values) ...<Widget>[
                    _RailDestination(
                      label: _labelFor(section),
                      icon: _iconFor(section),
                      isSelected: selectedSection == section,
                      showLabel: !hideLabels,
                      onPressed: () => onSelected(section),
                    ),
                    if (section != PlannerSection.values.last) const SizedBox(height: 9),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _labelFor(PlannerSection section) => switch (section) {
    PlannerSection.today => 'Today',
    PlannerSection.projects => 'Board',
    PlannerSection.focus => 'Focus',
  };

  IconData _iconFor(PlannerSection section) => switch (section) {
    PlannerSection.today => Icons.today_rounded,
    PlannerSection.projects => Icons.view_kanban_rounded,
    PlannerSection.focus => Icons.center_focus_strong_rounded,
  };
}

class _DateStamp extends StatelessWidget {
  const _DateStamp();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Semantics(
      label: 'Thursday, 11 September',
      child: Container(
        width: 50,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(color: colors.secondary, borderRadius: const BorderRadius.all(Radius.circular(17))),
        child: Column(
          children: <Widget>[
            Text(
              'SEP',
              style: TextStyle(color: colors.onSecondary, fontSize: 9, fontWeight: FontWeight.w700),
            ),
            Text(
              '11',
              style: TextStyle(color: colors.onSecondary, fontSize: 23, fontWeight: FontWeight.w800, height: 1),
            ),
          ],
        ),
      ),
    );
  }
}

class _RailDestination extends StatelessWidget {
  const _RailDestination({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.showLabel,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final bool showLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      child: Tooltip(
        message: label,
        child: Material(
          color: isSelected ? colors.primary : Colors.transparent,
          borderRadius: const BorderRadius.all(Radius.circular(19)),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onPressed,
            child: SizedBox(
              height: showLabel ? 67 : 52,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(icon, color: isSelected ? colors.onPrimary : colors.onSurfaceVariant, size: 22),
                  if (showLabel) ...<Widget>[
                    const SizedBox(height: 5),
                    Text(
                      label,
                      maxLines: 1,
                      style: TextStyle(
                        color: isSelected ? colors.onPrimary : colors.onSurfaceVariant,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
