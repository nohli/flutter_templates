import 'package:flutter/material.dart';

import '../models/planner_task.dart';
import '../planner_app_theme.dart';

class PlannerTaskTile extends StatelessWidget {
  const PlannerTaskTile({required this.task, required this.onToggle, super.key});

  final PlannerTask task;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final isDone = task.status == PlannerTaskStatus.done;
    final colors = _colorsFor(task.kind);

    return Semantics(
      container: true,
      label: '${task.title}, ${task.project}, ${isDone ? 'completed' : task.timeLabel}',
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
        decoration: const BoxDecoration(
          color: PlannerAppTheme.surface,
          borderRadius: BorderRadius.all(Radius.circular(22)),
          boxShadow: PlannerAppTheme.softShadow,
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: colors.background,
                borderRadius: const BorderRadius.all(Radius.circular(14)),
              ),
              alignment: Alignment.center,
              child: Icon(_iconFor(task.kind), color: colors.foreground, size: 21),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    task.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      decoration: isDone ? TextDecoration.lineThrough : null,
                      color: isDone ? PlannerAppTheme.mutedInk : PlannerAppTheme.ink,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${task.project} · ${task.timeLabel}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: PlannerAppTheme.mutedInk, fontSize: 11),
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: isDone ? 'Mark ${task.title} incomplete' : 'Complete ${task.title}',
              onPressed: onToggle,
              icon: AnimatedSwitcher(
                duration: MediaQuery.disableAnimationsOf(context) ? Duration.zero : const Duration(milliseconds: 180),
                child: Icon(
                  isDone ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                  key: ValueKey<bool>(isDone),
                  color: isDone ? PlannerAppTheme.primary : PlannerAppTheme.mutedInk,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ({Color background, Color foreground}) _colorsFor(PlannerTaskKind kind) => switch (kind) {
    PlannerTaskKind.design => (background: PlannerAppTheme.peach, foreground: const Color(0xFF9A442D)),
    PlannerTaskKind.research => (background: PlannerAppTheme.sky, foreground: const Color(0xFF245E8E)),
    PlannerTaskKind.writing => (background: const Color(0xFFE3DDF8), foreground: const Color(0xFF59469A)),
    PlannerTaskKind.planning => (background: PlannerAppTheme.lime, foreground: PlannerAppTheme.navy),
  };

  IconData _iconFor(PlannerTaskKind kind) => switch (kind) {
    PlannerTaskKind.design => Icons.auto_awesome_rounded,
    PlannerTaskKind.research => Icons.travel_explore_rounded,
    PlannerTaskKind.writing => Icons.edit_note_rounded,
    PlannerTaskKind.planning => Icons.view_timeline_rounded,
  };
}
