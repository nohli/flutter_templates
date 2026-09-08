import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../fitness_app_theme.dart';

class WaveView extends StatefulWidget {
  const WaveView({super.key, this.percentageValue = 100.0});

  final double percentageValue;

  @override
  State<WaveView> createState() => _WaveViewState();
}

class _WaveViewState extends State<WaveView> with TickerProviderStateMixin {
  late final AnimationController animationController;
  late final AnimationController waveAnimationController;
  late final Listenable animations;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
    waveAnimationController = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
    animations = Listenable.merge(<Listenable>[animationController, waveAnimationController]);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final animationsAreDisabled = MediaQuery.disableAnimationsOf(context);
    if (animationsAreDisabled) {
      animationController.stop();
      waveAnimationController.stop();
      animationController.value = 1;
      waveAnimationController.value = 0;
      return;
    }

    if (!animationController.isAnimating) {
      animationController.repeat(reverse: true);
    }
    if (!waveAnimationController.isAnimating) {
      waveAnimationController.repeat();
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    waveAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final useAccessibleLabel = MediaQuery.textScalerOf(context).scale(1) >= 2;
    final labelColor = useAccessibleLabel ? colors.onSurface : FitnessAppTheme.white;
    final labelChildren = <Widget>[
      Text(
        widget.percentageValue.round().toString(),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: FitnessAppTheme.fontName,
          fontWeight: FontWeight.w500,
          fontSize: 23,
          letterSpacing: 0.0,
          color: labelColor,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 3.0),
        child: Text(
          '%',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: FitnessAppTheme.fontName,
            fontWeight: FontWeight.w500,
            fontSize: 14,
            letterSpacing: 0.0,
            color: labelColor,
          ),
        ),
      ),
    ];
    final percentageLabel = useAccessibleLabel
        ? DecoratedBox(
            decoration: BoxDecoration(
              color: colors.surfaceContainerHighest.withValues(alpha: 0.92),
              borderRadius: const BorderRadius.all(Radius.circular(16)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              child: Wrap(
                alignment: WrapAlignment.center,
                runAlignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: labelChildren,
              ),
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: labelChildren,
          );

    return Container(
      alignment: Alignment.center,
      child: AnimatedBuilder(
        animation: animations,
        builder: (_, _) {
          final double phase = waveAnimationController.value * 2 * math.pi;
          final double verticalOffset = math.sin(phase) * 4 + ((100 - widget.percentageValue) * 160 / 100);
          return Stack(
            children: <Widget>[
              ClipPath(
                clipper: WaveClipper(verticalOffset: verticalOffset, horizontalOffset: 0),
                child: Container(
                  decoration: BoxDecoration(
                    color: FitnessAppTheme.nearlyDarkBlue.withValues(alpha: 0.5),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(80.0),
                      bottomLeft: Radius.circular(80.0),
                      bottomRight: Radius.circular(80.0),
                      topRight: Radius.circular(80.0),
                    ),
                    gradient: LinearGradient(
                      colors: <Color>[
                        FitnessAppTheme.nearlyDarkBlue.withValues(alpha: 0.2),
                        FitnessAppTheme.nearlyDarkBlue.withValues(alpha: 0.5),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
              ClipPath(
                clipper: WaveClipper(verticalOffset: verticalOffset, horizontalOffset: 60),
                child: Container(
                  decoration: BoxDecoration(
                    color: FitnessAppTheme.nearlyDarkBlue,
                    gradient: LinearGradient(
                      colors: <Color>[
                        FitnessAppTheme.nearlyDarkBlue.withValues(alpha: 0.4),
                        FitnessAppTheme.nearlyDarkBlue,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(80.0),
                      bottomLeft: Radius.circular(80.0),
                      bottomRight: Radius.circular(80.0),
                      topRight: Radius.circular(80.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 48),
                child: Center(child: percentageLabel),
              ),
              Positioned(
                top: 0,
                left: 6,
                bottom: 8,
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: animationController,
                      curve: const Interval(0.0, 1.0, curve: Curves.fastOutSlowIn),
                    ),
                  ),
                  child: Container(
                    width: 2,
                    height: 2,
                    decoration: BoxDecoration(
                      color: FitnessAppTheme.white.withValues(alpha: 0.4),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 24,
                right: 0,
                bottom: 16,
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: animationController,
                      curve: const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
                    ),
                  ),
                  child: Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: FitnessAppTheme.white.withValues(alpha: 0.4),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 24,
                bottom: 32,
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: animationController,
                      curve: const Interval(0.6, 0.8, curve: Curves.fastOutSlowIn),
                    ),
                  ),
                  child: Container(
                    width: 3,
                    height: 3,
                    decoration: BoxDecoration(
                      color: FitnessAppTheme.white.withValues(alpha: 0.4),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                right: 20,
                bottom: 0,
                child: Transform(
                  transform: Matrix4.translationValues(0.0, 16 * (1.0 - animationController.value), 0.0),
                  child: Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: FitnessAppTheme.white.withValues(
                        alpha: animationController.status == AnimationStatus.reverse ? 0.0 : 0.4,
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              Column(
                children: <Widget>[AspectRatio(aspectRatio: 1, child: Image.asset('assets/fitness_app/bottle.png'))],
              ),
            ],
          );
        },
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  const WaveClipper({required this.verticalOffset, required this.horizontalOffset});

  final double verticalOffset;
  final double horizontalOffset;

  @override
  Path getClip(Size size) {
    final path = Path();

    final int horizontalShift = horizontalOffset.toInt();
    final wavePoints = <Offset>[
      for (int i = -2 - horizontalShift; i <= 62; i++) Offset(i.toDouble() + horizontalShift, verticalOffset),
    ];
    path.addPolygon(wavePoints, false);

    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(WaveClipper oldClipper) =>
      verticalOffset != oldClipper.verticalOffset || horizontalOffset != oldClipper.horizontalOffset;
}
