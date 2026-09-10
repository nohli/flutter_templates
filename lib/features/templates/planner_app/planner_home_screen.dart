import 'package:flutter/material.dart';

import 'models/planner_section.dart';
import 'models/planner_task.dart';
import 'planner_app_theme.dart';
import 'sections/planner_focus_section.dart';
import 'sections/planner_projects_section.dart';
import 'sections/planner_today_section.dart';
import 'widgets/planner_bottom_bar.dart';

class PlannerHomeScreen extends StatefulWidget {
  const PlannerHomeScreen({super.key});

  @override
  State<PlannerHomeScreen> createState() => _PlannerHomeScreenState();
}

class _PlannerHomeScreenState extends State<PlannerHomeScreen> {
  late final _scrollControllers = <PlannerSection, ScrollController>{
    for (final section in PlannerSection.values) section: ScrollController(),
  };
  final _taskController = TextEditingController();
  final _tasks = PlannerTask.samples.toList();
  var _selectedSection = PlannerSection.today;
  var _focusIsRunning = false;

  @override
  void dispose() {
    _taskController.dispose();
    for (final controller in _scrollControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scrollController = _scrollControllers[_selectedSection]!;

    return Theme(
      data: PlannerAppTheme.build(),
      child: PrimaryScrollController(
        controller: scrollController,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: PlannerAppTheme.background,
            surfaceTintColor: Colors.transparent,
            leading: Navigator.of(context).canPop()
                ? IconButton(
                    tooltip: 'Back to template gallery',
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_rounded),
                  )
                : null,
            title: const Text('DAYMARK', style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1.5)),
            actions: <Widget>[
              IconButton(
                tooltip: 'Planner notifications',
                onPressed: () => _showMessage('No new sample notifications.'),
                icon: const Badge(smallSize: 7, child: Icon(Icons.notifications_none_rounded)),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: IndexedStack(
            index: _selectedSection.index,
            children: <Widget>[
              PlannerTodaySection(
                tasks: _tasks,
                scrollController: _scrollControllers[PlannerSection.today]!,
                taskController: _taskController,
                onAddTask: _addTask,
                onToggleTask: _toggleTask,
              ),
              PlannerProjectsSection(tasks: _tasks, scrollController: _scrollControllers[PlannerSection.projects]!),
              PlannerFocusSection(
                isRunning: _focusIsRunning,
                scrollController: _scrollControllers[PlannerSection.focus]!,
                onToggle: () {
                  setState(() {
                    _focusIsRunning = !_focusIsRunning;
                  });
                },
              ),
            ],
          ),
          bottomNavigationBar: PlannerBottomBar(selectedSection: _selectedSection, onSelected: _selectSection),
        ),
      ),
    );
  }

  void _addTask() {
    final title = _taskController.text.trim();
    if (title.isEmpty) {
      _showMessage('Write a task before adding it.');
      return;
    }

    setState(() {
      _tasks.insert(
        0,
        PlannerTask(
          id: 'custom-${_tasks.length}',
          title: title,
          project: 'Inbox',
          timeLabel: 'Anytime',
          status: PlannerTaskStatus.next,
          kind: PlannerTaskKind.planning,
        ),
      );
      _taskController.clear();
    });
  }

  void _toggleTask(PlannerTask task) {
    final index = _tasks.indexWhere((PlannerTask candidate) => candidate.id == task.id);
    final nextStatus = task.status == PlannerTaskStatus.done ? PlannerTaskStatus.next : PlannerTaskStatus.done;
    setState(() {
      _tasks[index] = task.copyWith(status: nextStatus);
    });
  }

  void _selectSection(PlannerSection section) {
    if (section == _selectedSection) {
      final controller = _scrollControllers[section]!;
      if (controller.hasClients) {
        if (MediaQuery.disableAnimationsOf(context)) {
          controller.jumpTo(0);
        } else {
          controller.animateTo(0, duration: const Duration(milliseconds: 260), curve: Curves.easeOutCubic);
        }
      }
      return;
    }
    setState(() {
      _selectedSection = section;
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
