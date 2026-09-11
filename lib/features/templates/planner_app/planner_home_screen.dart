import 'package:flutter/material.dart';

import '../../../app/app_appearance.dart';
import '../shared/template_appearance.dart';
import '../shared/template_motion.dart';
import 'models/planner_section.dart';
import 'models/planner_task.dart';
import 'planner_app_theme.dart';
import 'sections/planner_focus_section.dart';
import 'sections/planner_projects_section.dart';
import 'sections/planner_today_section.dart';
import 'widgets/planner_day_rail.dart';

class PlannerHomeScreen extends StatefulWidget {
  const PlannerHomeScreen({this.appearance = AppAppearance.light, super.key});

  final AppAppearance appearance;

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

    return TemplateAppearanceShell(
      appearance: widget.appearance,
      themeBuilder: PlannerAppTheme.build,
      builder: (BuildContext context) {
        return PrimaryScrollController(
          controller: scrollController,
          child: Scaffold(
            appBar: AppBar(
              surfaceTintColor: Colors.transparent,
              leading: Navigator.of(context).canPop()
                  ? IconButton(
                      tooltip: 'Back to template gallery',
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back_rounded),
                    )
                  : null,
              title: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Daymark', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, letterSpacing: -0.5)),
                  Text('Thursday, 11 September', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400)),
                ],
              ),
              actions: <Widget>[
                IconButton(
                  tooltip: 'Planner notifications',
                  onPressed: () => _showMessage('No new sample notifications.'),
                  icon: const Badge(smallSize: 7, child: Icon(Icons.notifications_none_rounded)),
                ),
                const SizedBox(width: 8),
              ],
            ),
            body: TemplateEntrance(
              child: Row(
                children: <Widget>[
                  PlannerDayRail(selectedSection: _selectedSection, onSelected: _selectSection),
                  Expanded(
                    child: TemplateSectionSwitcher(
                      selectedIndex: _selectedSection.index,
                      children: <Widget>[
                        PlannerTodaySection(
                          tasks: _tasks,
                          scrollController: _scrollControllers[PlannerSection.today]!,
                          taskController: _taskController,
                          onAddTask: _addTask,
                          onToggleTask: _toggleTask,
                        ),
                        PlannerProjectsSection(
                          tasks: _tasks,
                          scrollController: _scrollControllers[PlannerSection.projects]!,
                        ),
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
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
