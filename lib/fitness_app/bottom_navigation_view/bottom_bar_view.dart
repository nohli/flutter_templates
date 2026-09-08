import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../fitness_app_theme.dart';

class BottomBarView extends StatefulWidget {
  const BottomBarView({required this.selectedIndex, required this.onDestinationSelected, super.key});

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  static const double extent = 100;
  static const double contentGap = 16;

  static double contentPadding(BuildContext context) {
    return extent + MediaQuery.paddingOf(context).bottom + contentGap;
  }

  @override
  State<BottomBarView> createState() => _BottomBarViewState();
}

class _BottomBarViewState extends State<BottomBarView> with TickerProviderStateMixin {
  late final AnimationController _entranceController;
  late final AnimationController _selectionController;
  int? _animatingIndex;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
      animationBehavior: AnimationBehavior.preserve,
    );
    _selectionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      animationBehavior: AnimationBehavior.preserve,
    )..addStatusListener(_handleSelectionStatus);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _entranceController.value = 1;
      _selectionController.value = 0;
      _animatingIndex = null;
    } else if (!_entranceController.isAnimating && !_entranceController.isCompleted) {
      _entranceController.forward();
    }
  }

  void _handleSelectionStatus(AnimationStatus animationStatus) {
    if (animationStatus == AnimationStatus.completed) {
      _selectionController.reverse();
    } else if (animationStatus == AnimationStatus.dismissed && _animatingIndex != null && mounted) {
      setState(() {
        _animatingIndex = null;
      });
    }
  }

  void _selectDestination(int index) {
    if (widget.selectedIndex == index) {
      return;
    }

    if (!MediaQuery.disableAnimationsOf(context)) {
      _animatingIndex = null;
      _selectionController.value = 0;
      setState(() {
        _animatingIndex = index;
      });
      _selectionController.forward();
    }
    widget.onDestinationSelected(index);
  }

  Animation<double> _selectionAnimation(int index) {
    return _animatingIndex == index ? _selectionController : const AlwaysStoppedAnimation<double>(0);
  }

  @override
  void dispose() {
    _selectionController
      ..removeStatusListener(_handleSelectionStatus)
      ..dispose();
    _entranceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool animationsAreDisabled = MediaQuery.disableAnimationsOf(context);
    final Animation<double> entrance = animationsAreDisabled
        ? const AlwaysStoppedAnimation<double>(1)
        : CurvedAnimation(parent: _entranceController, curve: Curves.fastOutSlowIn);

    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: <Widget>[
        AnimatedBuilder(
          animation: entrance,
          builder: (BuildContext context, Widget? child) {
            return PhysicalShape(
              color: FitnessAppTheme.white,
              elevation: 16,
              clipper: TabClipper(radius: entrance.value * 38),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  height: 62,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8, top: 4),
                    child: Row(
                      children: <Widget>[
                        _TabButton(
                          destination: _destinations[0],
                          isSelected: widget.selectedIndex == 0,
                          selectionAnimation: _selectionAnimation(0),
                          onPressed: () => _selectDestination(0),
                        ),
                        _TabButton(
                          destination: _destinations[1],
                          isSelected: widget.selectedIndex == 1,
                          selectionAnimation: _selectionAnimation(1),
                          onPressed: () => _selectDestination(1),
                        ),
                        SizedBox(width: entrance.value * 64),
                        _TabButton(
                          destination: _destinations[2],
                          isSelected: widget.selectedIndex == 2,
                          selectionAnimation: _selectionAnimation(2),
                          onPressed: () => _selectDestination(2),
                        ),
                        _TabButton(
                          destination: _destinations[3],
                          isSelected: widget.selectedIndex == 3,
                          selectionAnimation: _selectionAnimation(3),
                          onPressed: () => _selectDestination(3),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        SafeArea(
          top: false,
          child: Align(
            alignment: Alignment.bottomCenter,
            heightFactor: 1,
            child: SizedBox(
              width: 76,
              height: BottomBarView.extent,
              child: Align(
                alignment: Alignment.topCenter,
                child: ScaleTransition(
                  scale: entrance,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: ExcludeSemantics(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: <Color>[FitnessAppTheme.nearlyDarkBlue, Color(0xFF6A88E5)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: FitnessAppTheme.nearlyDarkBlue.withValues(alpha: 0.4),
                              offset: const Offset(8, 16),
                              blurRadius: 16,
                            ),
                          ],
                        ),
                        child: const SizedBox.square(
                          dimension: 60,
                          child: Icon(Icons.add, color: FitnessAppTheme.white, size: 32),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.destination,
    required this.isSelected,
    required this.selectionAnimation,
    required this.onPressed,
  });

  final _TabDestination destination;
  final bool isSelected;
  final Animation<double> selectionAnimation;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Semantics(
        button: true,
        selected: isSelected,
        label: destination.accessibilityLabel,
        onTap: onPressed,
        child: ExcludeSemantics(
          child: Center(
            child: AspectRatio(
              aspectRatio: 1,
              child: InkWell(
                splashFactory: MediaQuery.disableAnimationsOf(context) ? NoSplash.splashFactory : null,
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                onTap: onPressed,
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: <Widget>[
                    ScaleTransition(
                      scale: Tween<double>(begin: 0.88, end: 1).animate(
                        CurvedAnimation(
                          parent: selectionAnimation,
                          curve: const Interval(0.1, 1, curve: Curves.fastOutSlowIn),
                        ),
                      ),
                      child: Image.asset(isSelected ? destination.selectedAsset : destination.asset),
                    ),
                    _SelectionDot(
                      animation: selectionAnimation,
                      interval: const Interval(0.2, 1, curve: Curves.fastOutSlowIn),
                      top: 4,
                      left: 6,
                      size: 8,
                    ),
                    _SelectionDot(
                      animation: selectionAnimation,
                      interval: const Interval(0.5, 0.8, curve: Curves.fastOutSlowIn),
                      top: 0,
                      left: 6,
                      size: 4,
                    ),
                    _SelectionDot(
                      animation: selectionAnimation,
                      interval: const Interval(0.5, 0.6, curve: Curves.fastOutSlowIn),
                      top: 6,
                      right: 8,
                      size: 6,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SelectionDot extends StatelessWidget {
  const _SelectionDot({
    required this.animation,
    required this.interval,
    required this.top,
    required this.size,
    this.left,
    this.right,
  });

  final Animation<double> animation;
  final Interval interval;
  final double top;
  final double? left;
  final double? right;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      child: ScaleTransition(
        scale: CurvedAnimation(parent: animation, curve: interval),
        child: SizedBox.square(
          dimension: size,
          child: const DecoratedBox(
            decoration: BoxDecoration(color: FitnessAppTheme.nearlyDarkBlue, shape: BoxShape.circle),
          ),
        ),
      ),
    );
  }
}

class _TabDestination {
  const _TabDestination({required this.asset, required this.selectedAsset, required this.accessibilityLabel});

  final String asset;
  final String selectedAsset;
  final String accessibilityLabel;
}

const _destinations = <_TabDestination>[
  _TabDestination(
    asset: 'assets/fitness_app/tab_1.png',
    selectedAsset: 'assets/fitness_app/tab_1s.png',
    accessibilityLabel: 'Diary',
  ),
  _TabDestination(
    asset: 'assets/fitness_app/tab_2.png',
    selectedAsset: 'assets/fitness_app/tab_2s.png',
    accessibilityLabel: 'Training',
  ),
  _TabDestination(
    asset: 'assets/fitness_app/tab_3.png',
    selectedAsset: 'assets/fitness_app/tab_3s.png',
    accessibilityLabel: 'Diary',
  ),
  _TabDestination(
    asset: 'assets/fitness_app/tab_4.png',
    selectedAsset: 'assets/fitness_app/tab_4s.png',
    accessibilityLabel: 'Training',
  ),
];

class TabClipper extends CustomClipper<Path> {
  TabClipper({this.radius = 38});

  final double radius;

  @override
  Path getClip(Size size) {
    final path = Path();
    final double diameter = radius * 2;

    path
      ..lineTo(0, 0)
      ..arcTo(Rect.fromLTWH(0, 0, radius, radius), _degreesToRadians(180), _degreesToRadians(90), false)
      ..arcTo(
        Rect.fromLTWH(((size.width / 2) - diameter / 2) - radius + diameter * 0.04, 0, radius, radius),
        _degreesToRadians(270),
        _degreesToRadians(70),
        false,
      )
      ..arcTo(
        Rect.fromLTWH((size.width / 2) - diameter / 2, -diameter / 2, diameter, diameter),
        _degreesToRadians(160),
        _degreesToRadians(-140),
        false,
      )
      ..arcTo(
        Rect.fromLTWH((size.width - ((size.width / 2) - diameter / 2)) - diameter * 0.04, 0, radius, radius),
        _degreesToRadians(200),
        _degreesToRadians(70),
        false,
      )
      ..arcTo(
        Rect.fromLTWH(size.width - radius, 0, radius, radius),
        _degreesToRadians(270),
        _degreesToRadians(90),
        false,
      )
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(TabClipper oldClipper) => oldClipper.radius != radius;
}

double _degreesToRadians(double degrees) => (math.pi / 180) * degrees;
