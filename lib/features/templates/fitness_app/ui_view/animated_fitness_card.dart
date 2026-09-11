import 'package:flutter/material.dart';

class AnimatedFitnessCard extends StatelessWidget {
  const AnimatedFitnessCard({
    required this.animation,
    required this.backgroundColor,
    required this.shadowColor,
    required this.builder,
    super.key,
  });

  final Animation<double> animation;
  final Color backgroundColor;
  final Color shadowColor;
  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, _) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(0, 30 * (1 - animation.value), 0),
            child: Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 18),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                    topRight: Radius.circular(68),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: shadowColor.withValues(alpha: 0.2),
                      offset: const Offset(1.1, 1.1),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: builder(context),
              ),
            ),
          ),
        );
      },
    );
  }
}
