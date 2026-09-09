import 'package:flutter/material.dart';

import 'design_course_app_theme.dart';
import 'models/category.dart';
import 'models/saved_courses.dart';

class CourseInfoScreen extends StatefulWidget {
  const CourseInfoScreen({required this.course, required this.savedCourses, super.key});

  final Category course;
  final SavedCourses savedCourses;

  @override
  State<CourseInfoScreen> createState() => _CourseInfoScreenState();
}

class _CourseInfoScreenState extends State<CourseInfoScreen> {
  var _factsOpacity = 0.0;
  var _descriptionOpacity = 0.0;
  var _noticeOpacity = 0.0;
  late final SavedCourses _savedCourses;
  late bool _isFavorite;
  var _animationsAreDisabled = false;
  var _entranceStarted = false;
  var _entranceSequence = 0;

  @override
  void initState() {
    super.initState();
    _savedCourses = widget.savedCourses;
    _isFavorite = _savedCourses.contains(widget.course);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _animationsAreDisabled = MediaQuery.disableAnimationsOf(context);
    if (_animationsAreDisabled) {
      _entranceStarted = true;
      _entranceSequence++;
      _factsOpacity = 1;
      _descriptionOpacity = 1;
      _noticeOpacity = 1;
      return;
    }

    if (_entranceStarted) return;

    _entranceStarted = true;
    _entranceSequence++;
    _revealContent(_entranceSequence);
  }

  Future<void> _revealContent(int sequence) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    if (!_canContinueEntrance(sequence)) return;

    setState(() {
      _factsOpacity = 1;
    });
    await Future<void>.delayed(const Duration(milliseconds: 200));
    if (!_canContinueEntrance(sequence)) return;

    setState(() {
      _descriptionOpacity = 1;
    });
    await Future<void>.delayed(const Duration(milliseconds: 200));
    if (!_canContinueEntrance(sequence)) return;

    setState(() {
      _noticeOpacity = 1;
    });
  }

  bool _canContinueEntrance(int sequence) => mounted && !_animationsAreDisabled && sequence == _entranceSequence;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final theme = DesignCourseAppTheme.build();
    final colors = theme.colorScheme;
    final naturalHeaderHeight = mediaQuery.size.width / 1.2;
    final headerHeight = naturalHeaderHeight.clamp(0, mediaQuery.size.height * 0.55).toDouble();
    final panelTop = headerHeight - 24;
    final opacityDuration = _animationsAreDisabled ? Duration.zero : const Duration(milliseconds: 500);

    return Theme(
      data: theme,
      child: Material(
        color: colors.surface,
        child: Stack(
          children: <Widget>[
            SizedBox(
              width: double.infinity,
              height: headerHeight,
              child: Image.asset(widget.course.imagePath, fit: BoxFit.cover),
            ),
            Positioned(
              top: panelTop,
              bottom: 0,
              left: 0,
              right: 0,
              child: _CourseDetailsPanel(
                course: widget.course,
                colors: colors,
                bottomInset: mediaQuery.padding.bottom,
                opacityDuration: opacityDuration,
                factsOpacity: _factsOpacity,
                descriptionOpacity: _descriptionOpacity,
                noticeOpacity: _noticeOpacity,
              ),
            ),
            Positioned(
              top: panelTop - 35,
              right: mediaQuery.padding.right + 35,
              child: _FavoriteButton(colors: colors, isFavorite: _isFavorite, onPressed: _toggleFavorite),
            ),
            _BackButton(colors: colors, topInset: mediaQuery.padding.top, leftInset: mediaQuery.padding.left),
          ],
        ),
      ),
    );
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = _savedCourses.toggle(widget.course);
    });
  }
}

class _CourseDetailsPanel extends StatelessWidget {
  const _CourseDetailsPanel({
    required this.course,
    required this.colors,
    required this.bottomInset,
    required this.opacityDuration,
    required this.factsOpacity,
    required this.descriptionOpacity,
    required this.noticeOpacity,
  });

  final Category course;
  final ColorScheme colors;
  final double bottomInset;
  final Duration opacityDuration;
  final double factsOpacity;
  final double descriptionOpacity;
  final double noticeOpacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
        boxShadow: <BoxShadow>[
          BoxShadow(color: colors.shadow.withValues(alpha: 0.2), offset: const Offset(1.1, 1.1), blurRadius: 10),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 32, left: 18, right: 16),
                      child: Text(
                        course.title,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 22,
                          letterSpacing: 0.27,
                          color: colors.onSurface,
                        ),
                      ),
                    ),
                    _CoursePriceAndRating(course: course, colors: colors),
                    AnimatedOpacity(
                      duration: opacityDuration,
                      opacity: factsOpacity,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 8,
                          runSpacing: 8,
                          children: <Widget>[
                            _CourseFact(value: '${course.lessonCount}', label: 'Classes', colors: colors),
                            _CourseFact(value: '2 hours', label: 'Time', colors: colors),
                            _CourseFact(value: '24', label: 'Seats', colors: colors),
                          ],
                        ),
                      ),
                    ),
                    AnimatedOpacity(
                      duration: opacityDuration,
                      opacity: descriptionOpacity,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 16),
                        child: Text(
                          'This fictional course demonstrates the course-details interface.',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w200,
                            fontSize: 14,
                            letterSpacing: 0.27,
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                    AnimatedOpacity(
                      duration: opacityDuration,
                      opacity: noticeOpacity,
                      child: _PreviewNotice(colors: colors),
                    ),
                    SizedBox(height: bottomInset),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CoursePriceAndRating extends StatelessWidget {
  const _CoursePriceAndRating({required this.course, required this.colors});

  final Category course;
  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8, top: 16),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 24,
        runSpacing: 8,
        children: <Widget>[
          Text(
            '\$${course.money}',
            textAlign: TextAlign.left,
            style: TextStyle(fontWeight: FontWeight.w200, fontSize: 22, letterSpacing: 0.27, color: colors.primary),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                '${course.rating}',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.w200,
                  fontSize: 22,
                  letterSpacing: 0.27,
                  color: colors.onSurfaceVariant,
                ),
              ),
              Icon(Icons.star, color: colors.primary, size: 24),
            ],
          ),
        ],
      ),
    );
  }
}

class _CourseFact extends StatelessWidget {
  const _CourseFact({required this.value, required this.label, required this.colors});

  final String value;
  final String label;
  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: colors.surfaceContainerLow,
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          boxShadow: <BoxShadow>[
            BoxShadow(color: colors.shadow.withValues(alpha: 0.2), offset: const Offset(1.1, 1.1), blurRadius: 8),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, letterSpacing: 0.27, color: colors.primary),
            ),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w200,
                fontSize: 14,
                letterSpacing: 0.27,
                color: colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PreviewNotice extends StatelessWidget {
  const _PreviewNotice({required this.colors});

  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 16, right: 16),
      child: Container(
        constraints: const BoxConstraints(minHeight: 48),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: colors.primaryContainer,
          borderRadius: const BorderRadius.all(Radius.circular(16)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(Icons.visibility_outlined, color: colors.onPrimaryContainer),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Preview only — enrollment is not available.',
                style: TextStyle(color: colors.onPrimaryContainer),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  const _FavoriteButton({required this.colors, required this.isFavorite, required this.onPressed});

  final ColorScheme colors;
  final bool isFavorite;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final label = isFavorite ? 'Remove saved sample course' : 'Save sample course';

    return Card(
      color: colors.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      elevation: 10,
      child: SizedBox(
        width: 60,
        height: 60,
        child: Center(
          child: Semantics(
            button: true,
            toggled: isFavorite,
            label: label,
            onTap: onPressed,
            child: ExcludeSemantics(
              child: IconButton(
                tooltip: label,
                constraints: const BoxConstraints.tightFor(width: 48, height: 48),
                isSelected: isFavorite,
                selectedIcon: Icon(Icons.favorite, color: colors.onPrimary, size: 28),
                icon: Icon(Icons.favorite_border, color: colors.onPrimary, size: 28),
                onPressed: onPressed,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.colors, required this.topInset, required this.leftInset});

  final ColorScheme colors;
  final double topInset;
  final double leftInset;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: topInset, left: leftInset + 8),
      child: SizedBox(
        width: kToolbarHeight,
        height: kToolbarHeight,
        child: Material(
          color: colors.surfaceContainerHigh,
          shape: const CircleBorder(),
          elevation: 4,
          child: Tooltip(
            message: 'Back',
            child: InkWell(
              borderRadius: BorderRadius.circular(kToolbarHeight),
              onTap: () => Navigator.pop(context),
              child: Icon(Icons.arrow_back_ios, color: colors.onSurface),
            ),
          ),
        ),
      ),
    );
  }
}
