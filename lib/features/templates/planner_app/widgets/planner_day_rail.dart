import 'package:flutter/material.dart';

import '../models/planner_section.dart';
import '../planner_app_theme.dart';

class PlannerDayRail extends StatelessWidget {
  const PlannerDayRail({required this.selectedSection, required this.onSelected, super.key});

  final PlannerSection selectedSection;
  final ValueChanged<PlannerSection> onSelected;

  @override
  Widget build(BuildContext context) {
    final hideLabels = MediaQuery.textScalerOf(context).scale(1) >= 1.8;

    return SizedBox(
      width: 76,
      child: DecoratedBox(
        decoration: const BoxDecoration(color: PlannerAppTheme.primary),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 12),
            const _DateStamp(),
            const SizedBox(height: 16),
            if (!hideLabels)
              const SizedBox(
                height: 116,
                child: RotatedBox(
                  quarterTurns: 3,
                  child: Center(
                    child: Text(
                      'DAYMARK / THURSDAY',
                      maxLines: 1,
                      style: TextStyle(
                        color: Color(0xBFFFFFFF),
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.6,
                      ),
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Container(height: 1, color: const Color(0x3DFFFFFF)),
            ),
            Expanded(
              child: ListView(
                primary: false,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
        width: 52,
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          color: colors.secondary,
          border: Border.all(color: const Color(0x5CFFFFFF)),
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        ),
        child: Column(
          children: <Widget>[
            Text(
              'SEP',
              style: TextStyle(color: colors.onSecondary, fontSize: 9, fontWeight: FontWeight.w700),
            ),
            Text(
              '11',
              style: TextStyle(
                color: colors.onSecondary,
                fontSize: 25,
                fontWeight: FontWeight.w800,
                letterSpacing: -1.5,
                height: 0.95,
              ),
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
    final selectedForeground = Theme.of(context).colorScheme.onSecondary;

    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      child: Tooltip(
        message: label,
        child: Material(
          color: isSelected ? PlannerAppTheme.lime : Colors.transparent,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: isSelected ? PlannerAppTheme.lime : const Color(0x47FFFFFF)),
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onPressed,
            child: SizedBox(
              height: showLabel ? 64 : 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(icon, color: isSelected ? selectedForeground : Colors.white, size: 21),
                  if (showLabel) ...<Widget>[
                    const SizedBox(height: 5),
                    Text(
                      label,
                      maxLines: 1,
                      style: TextStyle(
                        color: isSelected ? selectedForeground : Colors.white,
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
