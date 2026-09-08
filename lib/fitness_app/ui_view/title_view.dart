import 'package:flutter/material.dart';

class TitleView extends StatelessWidget {
  const TitleView({
    required this.animationController,
    required this.animation,
    this.title = '',
    this.actionLabel = '',
    super.key,
  });

  final String title;
  final String actionLabel;
  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final stackLabels = MediaQuery.textScalerOf(context).scale(1) >= 2;
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, _) {
        return Material(
          color: colors.surface,
          child: FadeTransition(
            opacity: animation,
            child: Transform(
              transform: Matrix4.translationValues(0.0, 30 * (1.0 - animation.value), 0.0),
              child: Padding(
                padding: const EdgeInsets.only(left: 24, right: 24),
                child: Flex(
                  direction: stackLabels ? Axis.vertical : Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (stackLabels)
                      Text(
                        title,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          letterSpacing: 0.5,
                          color: colors.onSurfaceVariant,
                        ),
                      )
                    else
                      Expanded(
                        child: Text(
                          title,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            letterSpacing: 0.5,
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ),
                    Padding(
                      padding: EdgeInsets.only(left: stackLabels ? 0 : 8, top: stackLabels ? 8 : 0),
                      child: Text(
                        actionLabel,
                        textAlign: stackLabels ? TextAlign.left : TextAlign.right,
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                          letterSpacing: 0.5,
                          color: colors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
