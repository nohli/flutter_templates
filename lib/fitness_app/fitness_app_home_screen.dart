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

class _FitnessAppHomeScreenState extends State<FitnessAppHomeScreen> with SingleTickerProviderStateMixin {
  var _selectedIndex = 0;

  late final AnimationController _animationController;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    startEntranceAnimation(context, _animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FitnessAppTheme.build();
    final tabBody = _selectedIndex.isEven
        ? MyDiaryScreen(animation: _animationController)
        : TrainingScreen(animation: _animationController);

    return Theme(
      data: theme,
      child: Material(
        color: theme.scaffoldBackgroundColor,
        child: Stack(children: <Widget>[tabBody, _buildBottomBar()]),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Column(
      children: <Widget>[
        const Expanded(child: SizedBox()),
        BottomBarView(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (int index) {
            final isNewDestination = index != _selectedIndex;
            if (!isNewDestination) return;

            setState(() {
              _selectedIndex = index;
            });
            restartTransitionAnimation(context, _animationController);
          },
        ),
      ],
    );
  }
}
