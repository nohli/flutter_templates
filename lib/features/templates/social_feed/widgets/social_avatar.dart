import 'package:flutter/material.dart';

class SocialAvatar extends StatelessWidget {
  const SocialAvatar({required this.initials, required this.colors, this.radius = 23, super.key});

  final String initials;
  final List<Color> colors;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: colors.first,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(colors: colors),
        ),
        child: SizedBox.expand(
          child: Center(
            child: Text(
              initials,
              style: TextStyle(color: Colors.white, fontSize: radius * 0.58, fontWeight: FontWeight.w800),
            ),
          ),
        ),
      ),
    );
  }
}
