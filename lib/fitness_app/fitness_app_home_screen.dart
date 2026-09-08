import 'package:flutter/material.dart';

import '../motion_preferences.dart';
import 'bottom_navigation_view/bottom_bar_view.dart';
import 'fitness_app_theme.dart';
import 'my_diary/my_diary_screen.dart';
import 'training/training_screen.dart';

class FitnessAppHomeScreen extends StatefulWidget {
  const FitnessAppHomeScreen({super.key});

  @override
  State<FitnessAppHomeScreen> createState() => _FitnessAppHomeScreenState();
}

class _FitnessAppHomeScreenState extends State<FitnessAppHomeScreen> with TickerProviderStateMixin {
  int selectedIndex = 0;

  late final AnimationController animationController;
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    startEntranceAnimation(context, animationController);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FitnessAppTheme.build();
    final tabBody = selectedIndex.isEven
        ? MyDiaryScreen(animationController: animationController)
        : TrainingScreen(animationController: animationController);

    return Theme(
      data: theme,
      child: Material(
        color: theme.scaffoldBackgroundColor,
        child: Stack(children: <Widget>[tabBody, bottomBar()]),
      ),
    );
  }

  Widget bottomBar() {
    return Column(
      children: <Widget>[
        const Expanded(child: SizedBox()),
        BottomBarView(
          selectedIndex: selectedIndex,
          onDestinationSelected: (int index) {
            final isNewDestination = index != selectedIndex;
            if (!isNewDestination) return;

            setState(() {
              selectedIndex = index;
            });
            restartTransitionAnimation(context, animationController);
          },
        ),
      ],
    );
  }
}
