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
        const _TodayHeading(),
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

class _TodayHeading extends StatelessWidget {
  const _TodayHeading();

  @override
  Widget build(BuildContext context) {
    final usesLargeText = MediaQuery.textScalerOf(context).scale(1) >= 2;
    const title = Text(
      'Make space for what matters.',
      style: TextStyle(fontSize: 27, fontWeight: FontWeight.w800, letterSpacing: -1, height: 1.02),
    );
    const day = Text('DAY / 256', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w700, letterSpacing: 1.1));

    if (usesLargeText) {
      return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[day, SizedBox(height: 10), title],
      );
    }

    return const Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(child: title),
        day,
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
    final usesLargeText = MediaQuery.textScalerOf(context).scale(1) >= 2;

    return Container(
      decoration: BoxDecoration(
        color: PlannerAppTheme.navy,
        border: Border.all(color: PlannerAppTheme.lime.withValues(alpha: 0.45)),
        borderRadius: const BorderRadius.all(Radius.circular(6)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: <Widget>[
          const Positioned.fill(child: CustomPaint(painter: _PlannerGridPainter())),
          Padding(
            padding: const EdgeInsets.all(20),
            child: usesLargeText
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _ProgressCopy(completedCount: completedCount, taskCount: taskCount),
                      const SizedBox(height: 18),
                      _ProgressMeter(progress: progress, completedCount: completedCount, taskCount: taskCount),
                    ],
                  )
                : Row(
                    children: <Widget>[
                      Expanded(
                        child: _ProgressCopy(completedCount: completedCount, taskCount: taskCount),
                      ),
                      const SizedBox(width: 18),
                      SizedBox(
                        width: 92,
                        child: _ProgressMeter(progress: progress, completedCount: completedCount, taskCount: taskCount),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _ProgressCopy extends StatelessWidget {
  const _ProgressCopy({required this.completedCount, required this.taskCount});

  final int completedCount;
  final int taskCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'SEPTEMBER / 11',
          style: TextStyle(color: PlannerAppTheme.lime, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.4),
        ),
        const SizedBox(height: 11),
        const Text(
          'A focused Thursday',
          style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800, height: 1.05),
        ),
        const SizedBox(height: 8),
        Text('$completedCount of $taskCount tasks complete', style: const TextStyle(color: Color(0xFFCDD5FA))),
      ],
    );
  }
}

class _ProgressMeter extends StatelessWidget {
  const _ProgressMeter({required this.progress, required this.completedCount, required this.taskCount});

  final double progress;
  final int completedCount;
  final int taskCount;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$completedCount of $taskCount tasks complete',
      child: ExcludeSemantics(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '${(progress * 100).round()}%',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 31,
                fontWeight: FontWeight.w800,
                letterSpacing: -1.8,
                height: 1,
              ),
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(1)),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: const Color(0x33FFFFFF),
                color: PlannerAppTheme.lime,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'DAY SCORE',
              style: TextStyle(color: Color(0xFF9DA8D3), fontSize: 8, fontWeight: FontWeight.w700, letterSpacing: 1.2),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlannerGridPainter extends CustomPainter {
  const _PlannerGridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0x12FFFFFF)
      ..strokeWidth = 0.6;
    for (var x = 0.0; x <= size.width; x += 28) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (var y = 0.0; y <= size.height; y += 28) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _PlannerGridPainter oldDelegate) => false;
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
        border: OutlineInputBorder(
          borderSide: BorderSide(color: colors.outlineVariant),
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colors.outlineVariant),
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        ),
      ),
    );
  }
}
