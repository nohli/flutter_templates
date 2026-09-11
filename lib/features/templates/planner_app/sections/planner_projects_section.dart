import 'package:flutter/material.dart';

import '../models/planner_task.dart';
import '../planner_app_theme.dart';

class PlannerProjectsSection extends StatelessWidget {
  const PlannerProjectsSection({required this.tasks, required this.scrollController, super.key});

  final List<PlannerTask> tasks;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ListView(
      key: const PageStorageKey<String>('planner-projects'),
      controller: scrollController,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
      children: <Widget>[
        const Text('Projects in motion', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Text(
          'A compact board pattern that stays readable on mobile.',
          style: TextStyle(color: colors.onSurfaceVariant),
        ),
        const SizedBox(height: 20),
        for (final status in PlannerTaskStatus.values) ...<Widget>[
          _BoardColumn(status: status, tasks: tasks.where((PlannerTask task) => task.status == status).toList()),
          if (status != PlannerTaskStatus.values.last) const SizedBox(height: 14),
        ],
      ],
    );
  }
}

class _BoardColumn extends StatelessWidget {
  const _BoardColumn({required this.status, required this.tasks});

  final PlannerTaskStatus status;
  final List<PlannerTask> tasks;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.all(Radius.circular(24)),
        boxShadow: PlannerAppTheme.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 9,
                height: 9,
                decoration: BoxDecoration(color: _colorFor(status), shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(_labelFor(status), style: const TextStyle(fontWeight: FontWeight.w700)),
              ),
              Text('${tasks.length}', style: TextStyle(color: colors.onSurfaceVariant)),
            ],
          ),
          const SizedBox(height: 12),
          if (tasks.isEmpty)
            Text('Nothing here', style: TextStyle(color: colors.onSurfaceVariant))
          else
            for (final task in tasks) ...<Widget>[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(task.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 5),
                    Text(task.project, style: TextStyle(color: colors.onSurfaceVariant, fontSize: 12)),
                  ],
                ),
              ),
              if (task != tasks.last) const SizedBox(height: 8),
            ],
        ],
      ),
    );
  }

  String _labelFor(PlannerTaskStatus status) => switch (status) {
    PlannerTaskStatus.next => 'Next up',
    PlannerTaskStatus.inProgress => 'In progress',
    PlannerTaskStatus.done => 'Done',
  };

  Color _colorFor(PlannerTaskStatus status) => switch (status) {
    PlannerTaskStatus.next => const Color(0xFF5E86B0),
    PlannerTaskStatus.inProgress => PlannerAppTheme.primary,
    PlannerTaskStatus.done => const Color(0xFF6F8B27),
  };
}
