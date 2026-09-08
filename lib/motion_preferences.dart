import 'package:flutter/widgets.dart';

void startEntranceAnimation(BuildContext context, AnimationController controller) {
  final animationsAreDisabled = MediaQuery.disableAnimationsOf(context);
  if (animationsAreDisabled) {
    controller.value = controller.upperBound;
    return;
  }

  final canStart = controller.isDismissed && !controller.isAnimating;
  if (canStart) {
    controller.forward();
  }
}

void restartTransitionAnimation(BuildContext context, AnimationController controller) {
  final animationsAreDisabled = MediaQuery.disableAnimationsOf(context);
  if (animationsAreDisabled) {
    controller.value = controller.upperBound;
    return;
  }

  controller.forward(from: controller.lowerBound);
}
