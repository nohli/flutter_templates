import 'package:flutter/material.dart';

import '../ui_view/area_list_view.dart';
import '../ui_view/fitness_section_scaffold.dart';
import '../ui_view/running_view.dart';
import '../ui_view/title_view.dart';
import '../ui_view/workout_view.dart';

class TrainingScreen extends StatelessWidget {
  const TrainingScreen({required this.animation, super.key});

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    const count = 5;
    Animation<double> entrance(int index) => CurvedAnimation(
      parent: animation,
      curve: Interval(index / count, 1, curve: Curves.fastOutSlowIn),
    );

    return FitnessSectionScaffold(
      title: 'Training',
      animation: animation,
      sections: <Widget>[
        TitleView(title: 'Your program', actionLabel: 'Details', animation: entrance(0)),
        WorkoutView(animation: entrance(1)),
        RunningView(animation: entrance(2)),
        TitleView(title: 'Area of focus', actionLabel: 'More', animation: entrance(3)),
        AreaListView(mainScreenAnimation: entrance(4)),
      ],
    );
  }
}
