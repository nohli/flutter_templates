import 'package:flutter/material.dart';

class FinanceEntrance extends StatelessWidget {
  const FinanceEntrance({required this.animation, required this.index, required this.child, super.key});

  final Animation<double> animation;
  final int index;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final start = (index * 0.08).clamp(0.0, 0.48);
    final entrance = CurvedAnimation(
      parent: animation,
      curve: Interval(start, (start + 0.52).clamp(0.0, 1.0), curve: Curves.easeOutCubic),
    );

    return AnimatedBuilder(
      animation: entrance,
      child: child,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: entrance,
          child: Transform.translate(offset: Offset(0, 24 * (1 - entrance.value)), child: child),
        );
      },
    );
  }
}
