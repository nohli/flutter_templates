import 'package:flutter/material.dart';

import '../ui_view/body_measurement.dart';
import '../ui_view/fitness_section_scaffold.dart';
import '../ui_view/glass_view.dart';
import '../ui_view/mediterranean_diet_view.dart';
import '../ui_view/title_view.dart';
import 'meals_list_view.dart';
import 'water_view.dart';

class MyDiaryScreen extends StatelessWidget {
  const MyDiaryScreen({required this.animation, super.key});

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    const count = 9;
    Animation<double> entrance(int index) => CurvedAnimation(
      parent: animation,
      curve: Interval(index / count, 1, curve: Curves.fastOutSlowIn),
    );

    return FitnessSectionScaffold(
      title: 'My Diary',
      animation: animation,
      sections: <Widget>[
        TitleView(title: 'Mediterranean diet', actionLabel: 'Details', animation: entrance(0)),
        MediterraneanDietView(animation: entrance(1), macroAnimation: animation),
        TitleView(title: 'Meals today', actionLabel: 'Customize', animation: entrance(2)),
        MealsListView(mainScreenAnimation: entrance(3)),
        TitleView(title: 'Body measurement', actionLabel: 'Today', animation: entrance(4)),
        BodyMeasurementView(animation: entrance(5)),
        TitleView(title: 'Water', actionLabel: 'Aqua SmartBottle', animation: entrance(6)),
        WaterView(animation: entrance(7)),
        GlassView(animation: entrance(8)),
      ],
    );
  }
}
