import 'package:flutter/material.dart';

import 'design_course_app_theme.dart';
import 'models/category.dart';
import 'models/saved_courses.dart';

class CourseInfoScreen extends StatefulWidget {
  const CourseInfoScreen({required this.course, this.savedCourses, super.key});

  final Category course;
  final SavedCourses? savedCourses;

  @override
  State<CourseInfoScreen> createState() => _CourseInfoScreenState();
}

class _CourseInfoScreenState extends State<CourseInfoScreen> {
  var opacity1 = 0.0;
  var opacity2 = 0.0;
  var opacity3 = 0.0;
  late final SavedCourses _savedCourses;
  late bool isFavorite;
  var _animationsAreDisabled = false;
  var _entranceStarted = false;
  var _entranceSequence = 0;

  @override
  void initState() {
    super.initState();
    _savedCourses = widget.savedCourses ?? SavedCourses.shared;
    isFavorite = _savedCourses.contains(widget.course);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _animationsAreDisabled = MediaQuery.disableAnimationsOf(context);
    if (_animationsAreDisabled) {
      _entranceStarted = true;
      _entranceSequence++;
      opacity1 = 1;
      opacity2 = 1;
      opacity3 = 1;
      return;
    }

    if (_entranceStarted) return;

    _entranceStarted = true;
    _entranceSequence++;
    _revealContent(_entranceSequence);
  }

  Future<void> _revealContent(int sequence) async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    if (!_canContinueEntrance(sequence)) return;

    setState(() {
      opacity1 = 1.0;
    });
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    if (!_canContinueEntrance(sequence)) return;

    setState(() {
      opacity2 = 1.0;
    });
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    if (!_canContinueEntrance(sequence)) return;

    setState(() {
      opacity3 = 1.0;
    });
  }

  bool _canContinueEntrance(int sequence) => mounted && !_animationsAreDisabled && sequence == _entranceSequence;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final theme = DesignCourseAppTheme.build();
    final colors = theme.colorScheme;
    final naturalHeaderHeight = mediaQuery.size.width / 1.2;
    final headerHeight = naturalHeaderHeight.clamp(0.0, mediaQuery.size.height * 0.55).toDouble();
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
              child: Container(
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(32.0),
                    topRight: Radius.circular(32.0),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: colors.shadow.withValues(alpha: 0.2),
                      offset: const Offset(1.1, 1.1),
                      blurRadius: 10.0,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
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
                                padding: const EdgeInsets.only(top: 32.0, left: 18, right: 16),
                                child: Text(
                                  widget.course.title,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 22,
                                    letterSpacing: 0.27,
                                    color: colors.onSurface,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8, top: 16),
                                child: Wrap(
                                  alignment: WrapAlignment.spaceBetween,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  spacing: 24,
                                  runSpacing: 8,
                                  children: <Widget>[
                                    Text(
                                      '\$${widget.course.money}',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w200,
                                        fontSize: 22,
                                        letterSpacing: 0.27,
                                        color: colors.primary,
                                      ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(
                                          '${widget.course.rating}',
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
                              ),
                              AnimatedOpacity(
                                duration: opacityDuration,
                                opacity: opacity1,
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Wrap(
                                    alignment: WrapAlignment.center,
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: <Widget>[
                                      _buildCourseFact('${widget.course.lessonCount}', 'Classes', colors),
                                      _buildCourseFact('2 hours', 'Time', colors),
                                      _buildCourseFact('24', 'Seats', colors),
                                    ],
                                  ),
                                ),
                              ),
                              AnimatedOpacity(
                                duration: opacityDuration,
                                opacity: opacity2,
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
                                opacity: opacity3,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 16, bottom: 16, right: 16),
                                  child: Container(
                                    constraints: const BoxConstraints(minHeight: 48),
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    decoration: BoxDecoration(
                                      color: colors.primaryContainer,
                                      borderRadius: const BorderRadius.all(Radius.circular(16.0)),
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
                                ),
                              ),
                              SizedBox(height: mediaQuery.padding.bottom),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Positioned(
              top: panelTop - 35,
              right: mediaQuery.padding.right + 35,
              child: Card(
                color: colors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                elevation: 10.0,
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child: Center(
                    child: Semantics(
                      button: true,
                      toggled: isFavorite,
                      label: isFavorite ? 'Remove saved sample course' : 'Save sample course',
                      onTap: _toggleFavorite,
                      child: ExcludeSemantics(
                        child: IconButton(
                          tooltip: isFavorite ? 'Remove saved sample course' : 'Save sample course',
                          constraints: const BoxConstraints.tightFor(width: 48, height: 48),
                          isSelected: isFavorite,
                          selectedIcon: Icon(Icons.favorite, color: colors.onPrimary, size: 28),
                          icon: Icon(Icons.favorite_border, color: colors.onPrimary, size: 28),
                          onPressed: _toggleFavorite,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: mediaQuery.padding.top, left: mediaQuery.padding.left + 8),
              child: SizedBox(
                width: AppBar().preferredSize.height,
                height: AppBar().preferredSize.height,
                child: Material(
                  color: colors.surfaceContainerHigh,
                  shape: const CircleBorder(),
                  elevation: 4,
                  child: Tooltip(
                    message: 'Back',
                    child: InkWell(
                      borderRadius: BorderRadius.circular(AppBar().preferredSize.height),
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.arrow_back_ios, color: colors.onSurface),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleFavorite() {
    setState(() {
      isFavorite = _savedCourses.toggle(widget.course);
    });
  }

  Widget _buildCourseFact(String value, String label, ColorScheme colors) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: colors.surfaceContainerLow,
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(color: colors.shadow.withValues(alpha: 0.2), offset: const Offset(1.1, 1.1), blurRadius: 8.0),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 12.0, bottom: 12.0),
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
      ),
    );
  }
}
