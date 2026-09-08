import 'package:flutter/material.dart';

import '../bottom_navigation_view/bottom_bar_view.dart';
import '../fitness_app_theme.dart';
import '../ui_view/area_list_view.dart';
import '../ui_view/running_view.dart';
import '../ui_view/sample_date_header.dart';
import '../ui_view/title_view.dart';
import '../ui_view/workout_view.dart';

class TrainingScreen extends StatefulWidget {
  const TrainingScreen({required this.animationController, super.key});

  final AnimationController animationController;

  @override
  State<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> with TickerProviderStateMixin {
  final List<Widget> _sections = <Widget>[];
  double _topBarOpacity = 0.0;

  late final ScrollController _scrollController;
  late final Animation<double> _topBarAnimation;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: widget.animationController,
        curve: const Interval(0, 0.5, curve: Curves.fastOutSlowIn),
      ),
    );
    _addSections();
    _scrollController.addListener(() {
      if (_scrollController.offset >= 24) {
        if (_topBarOpacity != 1.0) {
          if (mounted) {
            setState(() {
              _topBarOpacity = 1.0;
            });
          }
        }
      } else if (_scrollController.offset <= 24 && _scrollController.offset >= 0) {
        if (_topBarOpacity != _scrollController.offset / 24) {
          if (mounted) {
            setState(() {
              _topBarOpacity = _scrollController.offset / 24;
            });
          }
        }
      } else if (_scrollController.offset <= 0) {
        if (_topBarOpacity != 0.0) {
          if (mounted) {
            setState(() {
              _topBarOpacity = 0.0;
            });
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _addSections() {
    const int count = 5;

    _sections.add(
      TitleView(
        title: 'Your program',
        actionLabel: 'Details',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: widget.animationController,
            curve: const Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn),
          ),
        ),
        animationController: widget.animationController,
      ),
    );

    _sections.add(
      WorkoutView(
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: widget.animationController,
            curve: const Interval((1 / count) * 1, 1.0, curve: Curves.fastOutSlowIn),
          ),
        ),
        animationController: widget.animationController,
      ),
    );

    _sections.add(
      RunningView(
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: widget.animationController,
            curve: const Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn),
          ),
        ),
        animationController: widget.animationController,
      ),
    );

    _sections.add(
      TitleView(
        title: 'Area of focus',
        actionLabel: 'More',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: widget.animationController,
            curve: const Interval((1 / count) * 3, 1.0, curve: Curves.fastOutSlowIn),
          ),
        ),
        animationController: widget.animationController,
      ),
    );

    _sections.add(
      AreaListView(
        mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: widget.animationController,
            curve: const Interval((1 / count) * 4, 1.0, curve: Curves.fastOutSlowIn),
          ),
        ),
        mainScreenAnimationController: widget.animationController,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final stackHeader = MediaQuery.textScalerOf(context).scale(1) >= 2;
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: stackHeader
          ? _buildStackedList(colors)
          : Stack(
              children: <Widget>[
                _buildMainList(),
                _buildAppBar(colors),
                SizedBox(height: MediaQuery.of(context).padding.bottom),
              ],
            ),
    );
  }

  Widget _buildMainList() {
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.only(
        top: AppBar().preferredSize.height + MediaQuery.of(context).padding.top + 24,
        bottom: BottomBarView.contentPadding(context),
      ),
      itemCount: _sections.length,
      itemBuilder: (BuildContext context, int index) {
        return _sections[index];
      },
    );
  }

  Widget _buildStackedList(ColorScheme colors) {
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.only(bottom: BottomBarView.contentPadding(context)),
      itemCount: _sections.length + 1,
      itemBuilder: (BuildContext context, int index) {
        return index == 0 ? _buildAppBar(colors) : _sections[index - 1];
      },
    );
  }

  Widget _buildAppBar(ColorScheme colors) {
    final stackHeader = MediaQuery.textScalerOf(context).scale(1) >= 2;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        AnimatedBuilder(
          animation: widget.animationController,
          builder: (BuildContext context, _) {
            return FadeTransition(
              opacity: _topBarAnimation,
              child: Transform(
                transform: Matrix4.translationValues(0.0, 30 * (1.0 - _topBarAnimation.value), 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: colors.surface.withValues(alpha: _topBarOpacity),
                    borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(32.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: colors.shadow.withValues(alpha: 0.4 * _topBarOpacity),
                        offset: const Offset(1.1, 1.1),
                        blurRadius: 10.0,
                      ),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: MediaQuery.of(context).padding.top),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 16,
                          right: 16,
                          top: 16 - 8.0 * _topBarOpacity,
                          bottom: 12 - 8.0 * _topBarOpacity,
                        ),
                        child: Flex(
                          direction: stackHeader ? Axis.vertical : Axis.horizontal,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            if (stackHeader)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Training',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontFamily: FitnessAppTheme.fontName,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 22 + 6 - 6 * _topBarOpacity,
                                    letterSpacing: 1.2,
                                    color: colors.onSurface,
                                  ),
                                ),
                              )
                            else
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Training',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontFamily: FitnessAppTheme.fontName,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 22 + 6 - 6 * _topBarOpacity,
                                      letterSpacing: 1.2,
                                      color: colors.onSurface,
                                    ),
                                  ),
                                ),
                              ),
                            Padding(
                              padding: EdgeInsets.only(left: 8, right: 8, top: stackHeader ? 8 : 0),
                              child: const SampleDateHeader(),
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
        ),
      ],
    );
  }
}
