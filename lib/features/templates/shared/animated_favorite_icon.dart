import 'package:flutter/material.dart';

class AnimatedFavoriteIcon extends StatelessWidget {
  const AnimatedFavoriteIcon({required this.isFavorite, required this.inactiveColor, this.size, super.key});

  static const activeColor = Color(0xFFE5484D);

  final bool isFavorite;
  final Color inactiveColor;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final duration = MediaQuery.disableAnimationsOf(context) ? Duration.zero : const Duration(milliseconds: 240);

    return AnimatedSwitcher(
      duration: duration,
      reverseDuration: duration,
      switchInCurve: Curves.easeOutBack,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (Widget child, Animation<double> animation) => FadeTransition(
        opacity: animation,
        child: ScaleTransition(scale: animation, child: child),
      ),
      child: Icon(
        isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
        key: ValueKey<bool>(isFavorite),
        color: isFavorite ? activeColor : inactiveColor,
        size: size,
      ),
    );
  }
}
