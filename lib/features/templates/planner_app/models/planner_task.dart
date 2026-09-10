enum PlannerTaskStatus { next, inProgress, done }

enum PlannerTaskKind { design, research, writing, planning }

class PlannerTask {
  const PlannerTask({
    required this.id,
    required this.title,
    required this.project,
    required this.timeLabel,
    required this.status,
    required this.kind,
  });

  final String id;
  final String title;
  final String project;
  final String timeLabel;
  final PlannerTaskStatus status;
  final PlannerTaskKind kind;

  PlannerTask copyWith({String? title, PlannerTaskStatus? status}) {
    return PlannerTask(
      id: id,
      title: title ?? this.title,
      project: project,
      timeLabel: timeLabel,
      status: status ?? this.status,
      kind: kind,
    );
  }

  static const samples = <PlannerTask>[
    PlannerTask(
      id: 'launch-review',
      title: 'Review the launch flow',
      project: 'Mobile refresh',
      timeLabel: '09:30',
      status: PlannerTaskStatus.inProgress,
      kind: PlannerTaskKind.design,
    ),
    PlannerTask(
      id: 'research-notes',
      title: 'Synthesize research notes',
      project: 'Customer insights',
      timeLabel: '11:00',
      status: PlannerTaskStatus.next,
      kind: PlannerTaskKind.research,
    ),
    PlannerTask(
      id: 'weekly-brief',
      title: 'Draft the weekly brief',
      project: 'Team rhythm',
      timeLabel: '14:00',
      status: PlannerTaskStatus.next,
      kind: PlannerTaskKind.writing,
    ),
    PlannerTask(
      id: 'roadmap',
      title: 'Shape next sprint',
      project: 'Mobile refresh',
      timeLabel: '16:30',
      status: PlannerTaskStatus.done,
      kind: PlannerTaskKind.planning,
    ),
  ];
}
