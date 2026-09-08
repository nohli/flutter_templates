import 'package:flutter/material.dart';

import '../motion_preferences.dart';
import 'design_course_app_theme.dart';
import 'models/category.dart';

class PopularCourseListView extends StatefulWidget {
  const PopularCourseListView({required this.courses, required this.onSelected, super.key});

  final List<Category> courses;
  final ValueChanged<Category> onSelected;

  @override
  State<PopularCourseListView> createState() => _PopularCourseListViewState();
}

class _PopularCourseListViewState extends State<PopularCourseListView> with TickerProviderStateMixin {
  late final AnimationController animationController;
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    startEntranceAnimation(context, animationController);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final useSingleColumn = textScale >= 2;
    final usesNormalGeometry = textScale <= 1;
    final itemHeight = 280 + (textScale - 1).clamp(0.0, 2.2).toDouble() * 150;
    final gridDelegate = usesNormalGeometry
        ? const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 32,
            crossAxisSpacing: 32,
            childAspectRatio: 0.8,
          )
        : SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: useSingleColumn ? 1 : 2,
            mainAxisSpacing: 32,
            crossAxisSpacing: 32,
            mainAxisExtent: itemHeight,
          );

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: GridView(
        padding: const EdgeInsets.all(8),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: gridDelegate,
        children: List<Widget>.generate(widget.courses.length, (int index) {
          final count = widget.courses.length;
          final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: animationController,
              curve: Interval((1 / count) * index, 1.0, curve: Curves.fastOutSlowIn),
            ),
          );
          return _PopularCourseCard(
            callback: () => widget.onSelected(widget.courses[index]),
            category: widget.courses[index],
            animation: animation,
            animationController: animationController,
          );
        }),
      ),
    );
  }
}

class _PopularCourseCard extends StatelessWidget {
  const _PopularCourseCard({
    required this.category,
    required this.animationController,
    required this.animation,
    required this.callback,
  });

  final VoidCallback callback;
  final Category category;
  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, _) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(0.0, 50 * (1.0 - animation.value), 0.0),
            child: Semantics(
              button: true,
              label: category.accessibilityLabel,
              excludeSemantics: true,
              onTap: callback,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                  excludeFromSemantics: true,
                  onTap: callback,
                  child: SizedBox.expand(
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Expanded(
                              child: Ink(
                                decoration: BoxDecoration(
                                  color: DesignCourseAppTheme.cardBackground,
                                  borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Expanded(
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                                            child: Text(
                                              category.title,
                                              textAlign: TextAlign.left,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                                letterSpacing: 0.27,
                                                color: colors.onSurface,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 8),
                                            child: Wrap(
                                              alignment: WrapAlignment.spaceBetween,
                                              crossAxisAlignment: WrapCrossAlignment.center,
                                              spacing: 8,
                                              runSpacing: 4,
                                              children: <Widget>[
                                                Text(
                                                  category.lessonLabel,
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w200,
                                                    fontSize: 12,
                                                    letterSpacing: 0.27,
                                                    color: colors.onSurfaceVariant,
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: <Widget>[
                                                    Text(
                                                      '${category.rating}',
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.w200,
                                                        fontSize: 18,
                                                        letterSpacing: 0.27,
                                                        color: colors.onSurfaceVariant,
                                                      ),
                                                    ),
                                                    Icon(Icons.star, color: colors.primary, size: 20),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 48),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 48),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 24, right: 16, left: 16),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                              boxShadow: <BoxShadow>[
                                BoxShadow(color: colors.shadow.withValues(alpha: 0.2), blurRadius: 6.0),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                              child: AspectRatio(aspectRatio: 1.28, child: Image.asset(category.imagePath)),
                            ),
                          ),
                        ),
                      ],
                    ),
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
