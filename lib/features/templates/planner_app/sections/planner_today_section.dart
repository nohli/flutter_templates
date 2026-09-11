import 'package:flutter/material.dart';

import '../models/planner_task.dart';
import '../planner_app_theme.dart';
import '../widgets/planner_task_tile.dart';

class PlannerTodaySection extends StatelessWidget {
  const PlannerTodaySection({
    required this.tasks,
    required this.scrollController,
    required this.taskController,
    required this.onAddTask,
    required this.onToggleTask,
    super.key,
  });

  final List<PlannerTask> tasks;
  final ScrollController scrollController;
  final TextEditingController taskController;
  final VoidCallback onAddTask;
  final ValueChanged<PlannerTask> onToggleTask;

  @override
  Widget build(BuildContext context) {
    final completedCount = tasks.where((PlannerTask task) => task.status == PlannerTaskStatus.done).length;
    final progress = tasks.isEmpty ? 0.0 : completedCount / tasks.length;

    return ListView(
      key: const PageStorageKey<String>('planner-today'),
      controller: scrollController,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
      children: <Widget>[
        const Text(
          'Make space for what matters.',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700, height: 1.12),
        ),
        const SizedBox(height: 18),
        _DayProgress(completedCount: completedCount, taskCount: tasks.length, progress: progress),
        const SizedBox(height: 18),
        _QuickCapture(controller: taskController, onAddTask: onAddTask),
        const SizedBox(height: 26),
        const Text('Today', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        for (final task in tasks) ...<Widget>[
          PlannerTaskTile(task: task, onToggle: () => onToggleTask(task)),
          if (task != tasks.last) const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _DayProgress extends StatelessWidget {
  const _DayProgress({required this.completedCount, required this.taskCount, required this.progress});

  final int completedCount;
  final int taskCount;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[PlannerAppTheme.navy, Color(0xFF334996)],
        ),
        borderRadius: BorderRadius.all(Radius.circular(28)),
        boxShadow: PlannerAppTheme.softShadow,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'SEPTEMBER 11',
                  style: TextStyle(
                    color: PlannerAppTheme.lime,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'A focused Thursday',
                  style: TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text('$completedCount of $taskCount tasks complete', style: const TextStyle(color: Color(0xFFCDD5FA))),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Semantics(
            label: '$completedCount of $taskCount tasks complete',
            child: SizedBox.square(
              dimension: 70,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 7,
                    backgroundColor: const Color(0x33FFFFFF),
                    color: PlannerAppTheme.lime,
                  ),
                  Text(
                    '${(progress * 100).round()}%',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickCapture extends StatelessWidget {
  const _QuickCapture({required this.controller, required this.onAddTask});

  final TextEditingController controller;
  final VoidCallback onAddTask;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return TextField(
      controller: controller,
      textInputAction: TextInputAction.done,
      onSubmitted: (_) => onAddTask(),
      decoration: InputDecoration(
        hintText: 'Capture a task',
        prefixIcon: const Icon(Icons.add_task_rounded),
        suffixIcon: IconButton(tooltip: 'Add task', onPressed: onAddTask, icon: const Icon(Icons.arrow_upward_rounded)),
        filled: true,
        fillColor: colors.surface,
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(18)),
        ),
      ),
    );
  }
}
