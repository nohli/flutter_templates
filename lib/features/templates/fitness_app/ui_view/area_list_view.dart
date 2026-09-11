import 'package:flutter/material.dart';

import '../../../../app/motion_preferences.dart';

class AreaListView extends StatefulWidget {
  const AreaListView({required this.mainScreenAnimation, super.key});

  final Animation<double> mainScreenAnimation;
  @override
  State<AreaListView> createState() => _AreaListViewState();
}

class _AreaListViewState extends State<AreaListView> with SingleTickerProviderStateMixin {
  static const _imagePaths = <String>[
    'assets/fitness_app/area1.png',
    'assets/fitness_app/area2.png',
    'assets/fitness_app/area3.png',
    'assets/fitness_app/area1.png',
  ];

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
    return AnimatedBuilder(
      animation: widget.mainScreenAnimation,
      builder: (BuildContext context, _) {
        return FadeTransition(
          opacity: widget.mainScreenAnimation,
          child: Transform(
            transform: Matrix4.translationValues(0.0, 30 * (1.0 - widget.mainScreenAnimation.value), 0.0),
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8),
                child: GridView(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
                  primary: false,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 24.0,
                    crossAxisSpacing: 24.0,
                  ),
                  children: List<Widget>.generate(_imagePaths.length, (int index) {
                    final count = _imagePaths.length;
                    final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                        parent: _animationController,
                        curve: Interval((1 / count) * index, 1.0, curve: Curves.fastOutSlowIn),
                      ),
                    );
                    return _AreaCard(imagePath: _imagePaths[index], animation: animation);
                  }),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AreaCard extends StatelessWidget {
  const _AreaCard({required this.imagePath, required this.animation});

  final String imagePath;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, _) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(0.0, 50 * (1.0 - animation.value), 0.0),
            child: Container(
              decoration: BoxDecoration(
                color: colors.surfaceContainerLow,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  bottomLeft: Radius.circular(8.0),
                  bottomRight: Radius.circular(8.0),
                  topRight: Radius.circular(8.0),
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: colors.shadow.withValues(alpha: 0.3),
                    offset: const Offset(1.1, 1.1),
                    blurRadius: 10.0,
                  ),
                ],
              ),
              child: Semantics(
                image: true,
                label: 'Sample training focus illustration',
                child: ExcludeSemantics(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                    child: Image.asset(imagePath),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
