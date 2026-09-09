import 'package:flutter/material.dart';

import '../../motion_preferences.dart';
import '../fitness_app_theme.dart';
import '../models/meals_list_data.dart';

class MealsListView extends StatefulWidget {
  const MealsListView({required this.mainScreenAnimation, super.key});

  final Animation<double> mainScreenAnimation;

  @override
  State<MealsListView> createState() => _MealsListViewState();
}

class _MealsListViewState extends State<MealsListView> with SingleTickerProviderStateMixin {
  final _meals = MealsListData.samples;

  late final AnimationController _animationController;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
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
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final listHeight = 216 + (textScale - 1).clamp(0.0, 2.2).toDouble() * 260;
    return AnimatedBuilder(
      animation: widget.mainScreenAnimation,
      builder: (BuildContext context, _) {
        return FadeTransition(
          opacity: widget.mainScreenAnimation,
          child: Transform(
            transform: Matrix4.translationValues(0.0, 30 * (1.0 - widget.mainScreenAnimation.value), 0.0),
            child: SizedBox(
              height: listHeight,
              width: double.infinity,
              child: ListView.builder(
                padding: const EdgeInsets.only(right: 16, left: 16),
                itemCount: _meals.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  final count = _meals.length > 10 ? 10 : _meals.length;
                  final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: _animationController,
                      curve: Interval((1 / count) * index, 1.0, curve: Curves.fastOutSlowIn),
                    ),
                  );
                  return MealsView(mealsListData: _meals[index], animation: animation);
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class MealsView extends StatelessWidget {
  const MealsView({required this.mealsListData, required this.animation, super.key});

  final MealsListData mealsListData;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final useExpandedCard = textScale >= 2;
    final cardWidth = 130 + (textScale - 1).clamp(0.0, 2.2).toDouble() * 75;
    final contentColor = useExpandedCard ? colors.onSurface : FitnessAppTheme.white;
    Widget content = _buildContent(colors, contentColor, useExpandedCard);
    if (useExpandedCard) {
      content = DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surfaceContainerHighest,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: Padding(padding: const EdgeInsets.all(8), child: content),
      );
    }

    return AnimatedBuilder(
      animation: animation,
      builder: (_, _) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(100 * (1.0 - animation.value), 0.0, 0.0),
            child: SizedBox(
              width: cardWidth,
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 32, left: 8, right: 8, bottom: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: useExpandedCard
                                ? colors.shadow.withValues(alpha: 0.35)
                                : mealsListData.endColor.withValues(alpha: 0.6),
                            offset: const Offset(1.1, 4.0),
                            blurRadius: 8.0,
                          ),
                        ],
                        gradient: LinearGradient(
                          colors: <Color>[mealsListData.startColor, mealsListData.endColor],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(8.0),
                          bottomLeft: Radius.circular(8.0),
                          topLeft: Radius.circular(8.0),
                          topRight: Radius.circular(54.0),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: 54,
                          left: useExpandedCard ? 8 : 16,
                          right: useExpandedCard ? 8 : 16,
                          bottom: 8,
                        ),
                        child: content,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      width: 84,
                      height: 84,
                      decoration: BoxDecoration(
                        color: (useExpandedCard ? colors.surface : FitnessAppTheme.nearlyWhite).withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 8,
                    child: SizedBox(width: 80, height: 80, child: Image.asset(mealsListData.imagePath)),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(ColorScheme colors, Color contentColor, bool useExpandedCard) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          mealsListData.title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: FitnessAppTheme.fontName,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            letterSpacing: 0.2,
            color: contentColor,
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Align(
              alignment: Alignment.topLeft,
              child: useExpandedCard
                  ? Text(mealsListData.meals.join('\n'), style: _contentStyle(contentColor, 10))
                  : FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.topLeft,
                      child: Text(mealsListData.meals.join('\n'), style: _contentStyle(contentColor, 10)),
                    ),
            ),
          ),
        ),
        if (mealsListData.kcal case final kcal?)
          _buildEnergyLabel(kcal, contentColor, useExpandedCard)
        else
          _buildAddIcon(colors, useExpandedCard),
      ],
    );
  }

  Widget _buildEnergyLabel(int kcal, Color contentColor, bool useExpandedCard) {
    final value = Text('$kcal', textAlign: TextAlign.center, style: _contentStyle(contentColor, 24));
    final unit = Padding(
      padding: EdgeInsets.only(left: useExpandedCard ? 0 : 4, bottom: 3),
      child: Text('kcal', style: _contentStyle(contentColor, 10)),
    );

    if (useExpandedCard) {
      return Wrap(
        crossAxisAlignment: WrapCrossAlignment.end,
        spacing: 4,
        runSpacing: 4,
        children: <Widget>[value, unit],
      );
    }

    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.bottomLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[value, unit],
      ),
    );
  }

  Widget _buildAddIcon(ColorScheme colors, bool useExpandedCard) {
    return Container(
      decoration: BoxDecoration(
        color: useExpandedCard ? colors.surface : FitnessAppTheme.nearlyWhite,
        shape: BoxShape.circle,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: useExpandedCard
                ? colors.shadow.withValues(alpha: 0.3)
                : FitnessAppTheme.nearlyBlack.withValues(alpha: 0.4),
            offset: const Offset(8.0, 8.0),
            blurRadius: 8.0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Icon(Icons.add, color: useExpandedCard ? colors.primary : mealsListData.endColor, size: 24),
      ),
    );
  }

  TextStyle _contentStyle(Color color, double fontSize) {
    return TextStyle(
      fontFamily: FitnessAppTheme.fontName,
      fontWeight: FontWeight.w500,
      fontSize: fontSize,
      letterSpacing: 0.2,
      color: color,
    );
  }
}
