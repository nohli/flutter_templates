import 'package:flutter/material.dart';

import '../bottom_navigation_view/bottom_bar_view.dart';
import '../fitness_app_theme.dart';
import 'sample_date_header.dart';

class FitnessSectionScaffold extends StatefulWidget {
  const FitnessSectionScaffold({required this.title, required this.animation, required this.sections, super.key});

  final String title;
  final Animation<double> animation;
  final List<Widget> sections;

  @override
  State<FitnessSectionScaffold> createState() => _FitnessSectionScaffoldState();
}

class _FitnessSectionScaffoldState extends State<FitnessSectionScaffold> {
  final _scrollController = ScrollController();
  var _headerOpacity = 0.0;

  late final Animation<double> _headerAnimation;

  @override
  void initState() {
    super.initState();
    _headerAnimation = CurvedAnimation(
      parent: widget.animation,
      curve: const Interval(0, 0.5, curve: Curves.fastOutSlowIn),
    );
    _scrollController.addListener(_updateHeaderOpacity);
  }

  void _updateHeaderOpacity() {
    final opacity = (_scrollController.offset / 24).clamp(0.0, 1.0).toDouble();
    if (opacity == _headerOpacity) return;

    setState(() => _headerOpacity = opacity);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_updateHeaderOpacity)
      ..dispose();
    super.dispose();
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
                _buildHeader(colors, stackHeader: false),
                SizedBox(height: MediaQuery.paddingOf(context).bottom),
              ],
            ),
    );
  }

  Widget _buildMainList() {
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.only(
        top: kToolbarHeight + MediaQuery.paddingOf(context).top + 24,
        bottom: BottomBarView.contentPadding(context),
      ),
      itemCount: widget.sections.length,
      itemBuilder: (BuildContext context, int index) => widget.sections[index],
    );
  }

  Widget _buildStackedList(ColorScheme colors) {
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.only(bottom: BottomBarView.contentPadding(context)),
      itemCount: widget.sections.length + 1,
      itemBuilder: (BuildContext context, int index) {
        return index == 0 ? _buildHeader(colors, stackHeader: true) : widget.sections[index - 1];
      },
    );
  }

  Widget _buildHeader(ColorScheme colors, {required bool stackHeader}) {
    return AnimatedBuilder(
      animation: widget.animation,
      builder: (BuildContext context, _) {
        return FadeTransition(
          opacity: _headerAnimation,
          child: Transform(
            transform: Matrix4.translationValues(0, 30 * (1 - _headerAnimation.value), 0),
            child: Container(
              decoration: BoxDecoration(
                color: colors.surface.withValues(alpha: _headerOpacity),
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(32)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: colors.shadow.withValues(alpha: 0.4 * _headerOpacity),
                    offset: const Offset(1.1, 1.1),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: MediaQuery.paddingOf(context).top),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 16 - 8 * _headerOpacity,
                      bottom: 12 - 8 * _headerOpacity,
                    ),
                    child: Flex(
                      direction: stackHeader ? Axis.vertical : Axis.horizontal,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        if (stackHeader) _buildTitle(colors) else Expanded(child: _buildTitle(colors)),
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
    );
  }

  Widget _buildTitle(ColorScheme colors) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        widget.title,
        textAlign: TextAlign.left,
        style: TextStyle(
          fontFamily: FitnessAppTheme.fontName,
          fontWeight: FontWeight.w700,
          fontSize: 28 - 6 * _headerOpacity,
          letterSpacing: 1.2,
          color: colors.onSurface,
        ),
      ),
    );
  }
}
