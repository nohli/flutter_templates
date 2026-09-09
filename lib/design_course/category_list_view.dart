import 'package:flutter/material.dart';

import '../motion_preferences.dart';
import 'design_course_app_theme.dart';
import 'models/category.dart';

const double _baseListHeight = 134;
const double _baseCardWidth = 280;
const double _baseArtworkSize = 86;
const double _maximumArtworkSize = 120;
const double _baseContentInset = 72;

double _textScaleGrowth(BuildContext context) {
  final textScale = MediaQuery.textScalerOf(context).scale(1);

  return (textScale - 1).clamp(0.0, 2.2).toDouble();
}

class CategoryListView extends StatefulWidget {
  const CategoryListView({required this.categories, required this.onSelected, super.key});

  final List<Category> categories;
  final ValueChanged<Category> onSelected;

  @override
  State<CategoryListView> createState() => _CategoryListViewState();
}

class _CategoryListViewState extends State<CategoryListView> with SingleTickerProviderStateMixin {
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
    final scaleGrowth = _textScaleGrowth(context);
    final listHeight = _baseListHeight + scaleGrowth * 150;

    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      child: SizedBox(
        height: listHeight,
        width: double.infinity,
        child: ListView.builder(
          padding: const EdgeInsets.only(right: 16, left: 16),
          itemCount: widget.categories.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            final count = widget.categories.length > 10 ? 10 : widget.categories.length;
            final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: _animationController,
                curve: Interval((1 / count) * index, 1.0, curve: Curves.fastOutSlowIn),
              ),
            );
            return _CategoryCourseCard(
              category: widget.categories[index],
              animation: animation,
              callback: () => widget.onSelected(widget.categories[index]),
            );
          },
        ),
      ),
    );
  }
}

class _CategoryCourseCard extends StatelessWidget {
  const _CategoryCourseCard({required this.category, required this.animation, required this.callback});

  final VoidCallback callback;
  final Category category;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final scaleGrowth = _textScaleGrowth(context);
    final cardWidth = _baseCardWidth + scaleGrowth * 64;
    final artworkSize = (_baseArtworkSize + scaleGrowth * 16).clamp(_baseArtworkSize, _maximumArtworkSize).toDouble();
    final contentInset = _baseContentInset + artworkSize - _baseArtworkSize;

    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, _) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(100 * (1.0 - animation.value), 0.0, 0.0),
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
                  child: SizedBox(
                    width: cardWidth,
                    child: Stack(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            const SizedBox(width: 48),
                            Expanded(
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: DesignCourseAppTheme.cardBackground,
                                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                                ),
                                child: Row(
                                  children: <Widget>[
                                    SizedBox(width: contentInset),
                                    Expanded(
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(top: 16),
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
                                          const Expanded(child: SizedBox()),
                                          Padding(
                                            padding: const EdgeInsets.only(right: 16, bottom: 8),
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
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 10, right: 16),
                                            child: Wrap(
                                              alignment: WrapAlignment.spaceBetween,
                                              crossAxisAlignment: WrapCrossAlignment.start,
                                              spacing: 8,
                                              runSpacing: 4,
                                              children: <Widget>[
                                                Text(
                                                  '\$${category.money}',
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18,
                                                    letterSpacing: 0.27,
                                                    color: colors.primary,
                                                  ),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: colors.primary,
                                                    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                                                  ),
                                                  child: const Padding(
                                                    padding: EdgeInsets.all(4.0),
                                                    child: Icon(Icons.add, color: DesignCourseAppTheme.nearlyWhite),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 24, bottom: 24, left: 16),
                          child: Row(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                                child: SizedBox(
                                  width: artworkSize,
                                  height: artworkSize,
                                  child: Image.asset(category.imagePath, fit: BoxFit.cover),
                                ),
                              ),
                            ],
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
