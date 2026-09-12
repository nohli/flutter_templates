import 'package:flutter/material.dart';

import '../models/planner_task.dart';
import '../planner_app_theme.dart';

class PlannerTimeline extends StatelessWidget {
  const PlannerTimeline({required this.tasks, required this.onToggleTask, super.key});

  final List<PlannerTask> tasks;
  final ValueChanged<PlannerTask> onToggleTask;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border.all(color: colors.outlineVariant),
        borderRadius: const BorderRadius.all(Radius.circular(6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const _TimelineHeader(),
          Divider(height: 1, color: colors.outlineVariant),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Column(
              children: <Widget>[
                for (var index = 0; index < tasks.length; index++)
                  _TimelineEntry(
                    task: tasks[index],
                    isFirst: index == 0,
                    isLast: index == tasks.length - 1,
                    onToggle: () => onToggleTask(tasks[index]),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineHeader extends StatelessWidget {
  const _TimelineHeader();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'TIME MAP / TODAY',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: colors.onSurface,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '09:30 — 17:00',
                style: TextStyle(color: colors.onSurfaceVariant, fontSize: 10, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Row(
            children: <Widget>[
              Expanded(
                flex: 4,
                child: _DayPhase(label: 'DEEP', color: PlannerAppTheme.sky),
              ),
              SizedBox(width: 4),
              Expanded(
                flex: 3,
                child: _DayPhase(label: 'SYNC', color: PlannerAppTheme.peach),
              ),
              SizedBox(width: 4),
              Expanded(
                flex: 2,
                child: _DayPhase(label: 'WRAP', color: PlannerAppTheme.lime),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DayPhase extends StatelessWidget {
  const _DayPhase({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 22,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(color: color, borderRadius: const BorderRadius.all(Radius.circular(2))),
      child: Text(
        label,
        style: const TextStyle(color: PlannerAppTheme.navy, fontSize: 7, fontWeight: FontWeight.w900, letterSpacing: 1),
      ),
    );
  }
}

class _TimelineEntry extends StatelessWidget {
  const _TimelineEntry({required this.task, required this.isFirst, required this.isLast, required this.onToggle});

  final PlannerTask task;
  final bool isFirst;
  final bool isLast;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDone = task.status == PlannerTaskStatus.done;
    final accent = _accentFor(task.kind);
    final statusLabel = switch (task.status) {
      PlannerTaskStatus.inProgress => 'NOW',
      PlannerTaskStatus.next => 'NEXT',
      PlannerTaskStatus.done => 'DONE',
    };

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            width: 46,
            child: Padding(
              padding: const EdgeInsets.only(top: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    task.timeLabel,
                    maxLines: 1,
                    softWrap: false,
                    style: TextStyle(
                      color: colors.onSurface,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.4,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    statusLabel,
                    style: TextStyle(
                      color: isDone ? colors.onSurfaceVariant : accent,
                      fontSize: 7,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ),
          _TimelineRail(accent: accent, isFirst: isFirst, isLast: isLast, isDone: isDone),
          const SizedBox(width: 7),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Semantics(
                container: true,
                label: '${task.title}, ${task.project}, ${isDone ? 'completed' : task.timeLabel}',
                child: AnimatedContainer(
                  duration: MediaQuery.disableAnimationsOf(context) ? Duration.zero : const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  decoration: BoxDecoration(
                    color: isDone ? colors.secondary : colors.surfaceContainerHighest,
                    border: Border(left: BorderSide(color: isDone ? PlannerAppTheme.lime : accent, width: 5)),
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 9, 4, 9),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                task.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: isDone ? colors.onSecondary : colors.onSurface,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  decoration: isDone ? TextDecoration.lineThrough : null,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                task.project,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: isDone ? colors.onSecondary.withValues(alpha: 0.72) : colors.onSurfaceVariant,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          tooltip: isDone ? 'Mark ${task.title} incomplete' : 'Complete ${task.title}',
                          onPressed: onToggle,
                          icon: AnimatedSwitcher(
                            duration: MediaQuery.disableAnimationsOf(context)
                                ? Duration.zero
                                : const Duration(milliseconds: 180),
                            child: Icon(
                              isDone ? Icons.check_rounded : Icons.arrow_forward_rounded,
                              key: ValueKey<bool>(isDone),
                              color: isDone ? colors.onSecondary : accent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _accentFor(PlannerTaskKind kind) => switch (kind) {
    PlannerTaskKind.design => const Color(0xFFF06C4E),
    PlannerTaskKind.research => const Color(0xFF3B8ECE),
    PlannerTaskKind.writing => const Color(0xFF8A6BD1),
    PlannerTaskKind.planning => const Color(0xFF7A9500),
  };
}

class _TimelineRail extends StatelessWidget {
  const _TimelineRail({required this.accent, required this.isFirst, required this.isLast, required this.isDone});

  final Color accent;
  final bool isFirst;
  final bool isLast;
  final bool isDone;

  @override
  Widget build(BuildContext context) {
    final divider = Theme.of(context).colorScheme.outlineVariant;

    return SizedBox(
      width: 18,
      child: Column(
        children: <Widget>[
          Expanded(
            child: ColoredBox(color: isFirst ? Colors.transparent : divider, child: const SizedBox(width: 1)),
          ),
          AnimatedContainer(
            duration: MediaQuery.disableAnimationsOf(context) ? Duration.zero : const Duration(milliseconds: 220),
            width: 13,
            height: 13,
            transform: Matrix4.rotationZ(0.785),
            transformAlignment: Alignment.center,
            decoration: BoxDecoration(
              color: isDone ? PlannerAppTheme.lime : accent,
              border: Border.all(color: PlannerAppTheme.navy, width: 2),
            ),
          ),
          Expanded(
            child: ColoredBox(color: isLast ? Colors.transparent : divider, child: const SizedBox(width: 1)),
          ),
        ],
      ),
    );
  }
}
