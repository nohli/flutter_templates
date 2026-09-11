import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../fitness_app_theme.dart';

class WaveView extends StatefulWidget {
  const WaveView({super.key, this.percentageValue = 100});

  final double percentageValue;

  @override
  State<WaveView> createState() => _WaveViewState();
}

class _WaveViewState extends State<WaveView> with TickerProviderStateMixin {
  late final AnimationController _bubbleController;
  late final AnimationController _waveController;
  late final Listenable _animations;

  @override
  void initState() {
    super.initState();
    _bubbleController = AnimationController(duration: const Duration(seconds: 2), vsync: this);
    _waveController = AnimationController(duration: const Duration(seconds: 2), vsync: this);
    _animations = Listenable.merge(<Listenable>[_bubbleController, _waveController]);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final animationsAreDisabled = MediaQuery.disableAnimationsOf(context);

    if (animationsAreDisabled) {
      _bubbleController.stop();
      _waveController.stop();
      _bubbleController.value = 1;
      _waveController.value = 0;
      return;
    }

    if (!_bubbleController.isAnimating) {
      _bubbleController.repeat(reverse: true);
    }
    if (!_waveController.isAnimating) {
      _waveController.repeat();
    }
  }

  @override
  void dispose() {
    _bubbleController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final useAccessibleLabel = MediaQuery.textScalerOf(context).scale(1) >= 2;

    return Center(
      child: AnimatedBuilder(
        animation: _animations,
        builder: (_, _) {
          final phase = _waveController.value * 2 * math.pi;
          final verticalOffset = math.sin(phase) * 4 + ((100 - widget.percentageValue) * 160 / 100);

          return Stack(
            children: <Widget>[
              _WaveLayer(verticalOffset: verticalOffset, horizontalOffset: 0, isForeground: false),
              _WaveLayer(verticalOffset: verticalOffset, horizontalOffset: 60, isForeground: true),
              Padding(
                padding: const EdgeInsets.only(top: 48),
                child: Center(
                  child: _PercentageLabel(
                    percentage: widget.percentageValue.round(),
                    colors: colors,
                    useAccessibleBackground: useAccessibleLabel,
                  ),
                ),
              ),
              _Bubble(
                controller: _bubbleController,
                interval: const Interval(0, 1, curve: Curves.fastOutSlowIn),
                position: const _BubblePosition(top: 0, left: 6, bottom: 8),
                size: 2,
              ),
              _Bubble(
                controller: _bubbleController,
                interval: const Interval(0.4, 1, curve: Curves.fastOutSlowIn),
                position: const _BubblePosition(left: 24, right: 0, bottom: 16),
                size: 4,
              ),
              _Bubble(
                controller: _bubbleController,
                interval: const Interval(0.6, 0.8, curve: Curves.fastOutSlowIn),
                position: const _BubblePosition(left: 0, right: 24, bottom: 32),
                size: 3,
              ),
              Positioned(
                top: 0,
                right: 20,
                bottom: 0,
                child: Transform(
                  transform: Matrix4.translationValues(0, 16 * (1 - _bubbleController.value), 0),
                  child: Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: FitnessAppTheme.white.withValues(
                        alpha: _bubbleController.status == AnimationStatus.reverse ? 0 : 0.4,
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

class _PercentageLabel extends StatelessWidget {
  const _PercentageLabel({required this.percentage, required this.colors, required this.useAccessibleBackground});

  final int percentage;
  final ColorScheme colors;
  final bool useAccessibleBackground;

  @override
  Widget build(BuildContext context) {
    final labelColor = useAccessibleBackground ? colors.onSurface : FitnessAppTheme.white;
    final labelChildren = <Widget>[
      Text(
        '$percentage',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: FitnessAppTheme.fontName,
          fontWeight: FontWeight.w500,
          fontSize: 23,
          letterSpacing: 0,
          color: labelColor,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 3),
        child: Text(
          '%',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: FitnessAppTheme.fontName,
            fontWeight: FontWeight.w500,
            fontSize: 14,
            letterSpacing: 0,
            color: labelColor,
          ),
        ),
      ),
    ];

    if (!useAccessibleBackground) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: labelChildren,
      );
    }

    return DecoratedBox(
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
    );
  }
}

class _WaveLayer extends StatelessWidget {
  const _WaveLayer({required this.verticalOffset, required this.horizontalOffset, required this.isForeground});

  final double verticalOffset;
  final double horizontalOffset;
  final bool isForeground;

  @override
  Widget build(BuildContext context) {
    final color = FitnessAppTheme.nearlyDarkBlue;

    return ClipPath(
      clipper: WaveClipper(verticalOffset: verticalOffset, horizontalOffset: horizontalOffset),
      child: Container(
        decoration: BoxDecoration(
          color: isForeground ? color : color.withValues(alpha: 0.5),
          borderRadius: const BorderRadius.all(Radius.circular(80)),
          gradient: LinearGradient(
            colors: isForeground
                ? <Color>[color.withValues(alpha: 0.4), color]
                : <Color>[color.withValues(alpha: 0.2), color.withValues(alpha: 0.5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.controller, required this.interval, required this.position, required this.size});

  final AnimationController controller;
  final Interval interval;
  final _BubblePosition position;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: position.top,
      left: position.left,
      right: position.right,
      bottom: position.bottom,
      child: ScaleTransition(
        scale: CurvedAnimation(parent: controller, curve: interval),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(color: FitnessAppTheme.white.withValues(alpha: 0.4), shape: BoxShape.circle),
        ),
      ),
    );
  }
}

class _BubblePosition {
  const _BubblePosition({this.top, this.left, this.right, this.bottom});

  final double? top;
  final double? left;
  final double? right;
  final double? bottom;
}

class WaveClipper extends CustomClipper<Path> {
  const WaveClipper({required this.verticalOffset, required this.horizontalOffset});

  final double verticalOffset;
  final double horizontalOffset;

  @override
  Path getClip(Size size) {
    final path = Path();
    final horizontalShift = horizontalOffset.toInt();
    final wavePoints = <Offset>[
      for (int i = -2 - horizontalShift; i <= 62; i++) Offset(i.toDouble() + horizontalShift, verticalOffset),
    ];
    path
      ..addPolygon(wavePoints, false)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(WaveClipper oldClipper) {
    return verticalOffset != oldClipper.verticalOffset || horizontalOffset != oldClipper.horizontalOffset;
  }
}
