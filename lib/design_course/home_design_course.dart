import 'package:flutter/material.dart';

import 'category_list_view.dart';
import 'course_info_screen.dart';
import 'design_course_app_theme.dart';
import 'models/category.dart';
import 'models/saved_courses.dart';
import 'popular_course_list_view.dart';

class DesignCourseHomeScreen extends StatefulWidget {
  const DesignCourseHomeScreen({this.savedCourses, super.key});

  final SavedCourses? savedCourses;

  @override
  State<DesignCourseHomeScreen> createState() => _DesignCourseHomeScreenState();
}

class _DesignCourseHomeScreenState extends State<DesignCourseHomeScreen> {
  CategoryType _categoryType = CategoryType.ui;
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final theme = DesignCourseAppTheme.build();
    final colors = theme.colorScheme;
    return Theme(
      data: theme,
      child: Material(
        color: colors.surface,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).padding.top),
              _buildAppBar(colors),
              _buildSearchBar(colors),
              _buildCategorySection(colors),
              _buildPopularCourseSection(colors),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySection(ColorScheme colors) {
    final categories = _coursesMatchingQuery(
      _categoryType == CategoryType.ui ? Category.categoryList : const <Category>[],
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 18, right: 16),
          child: Text(
            'Category',
            textAlign: TextAlign.left,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22, letterSpacing: 0.27, color: colors.onSurface),
          ),
        ),
        const SizedBox(height: 16),
        Padding(padding: const EdgeInsets.only(left: 16, right: 16), child: _buildCategoryControls(colors)),
        const SizedBox(height: 16),
        if (categories.isEmpty)
          _EmptyCourses(
            message: _query.isEmpty
                ? 'No sample courses are included in this category.'
                : 'No sample courses match your search.',
          )
        else
          CategoryListView(categories: categories, onSelected: _openCourse),
      ],
    );
  }

  Widget _buildPopularCourseSection(ColorScheme colors) {
    final courses = _coursesMatchingQuery(Category.popularCourseList);

    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 18, right: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Popular Course',
            textAlign: TextAlign.left,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22, letterSpacing: 0.27, color: colors.onSurface),
          ),
          if (courses.isEmpty)
            const _EmptyCourses(message: 'No sample courses match your search.')
          else
            PopularCourseListView(courses: courses, onSelected: _openCourse),
        ],
      ),
    );
  }

  void _openCourse(Category course) {
    Navigator.push<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => MediaQuery.withNoTextScaling(
          child: CourseInfoScreen(course: course, savedCourses: widget.savedCourses),
        ),
      ),
    );
  }

  Widget _buildCategoryControls(ColorScheme colors) {
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final shouldStackControls = textScale >= 2;

    if (shouldStackControls) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _buildCategoryButton(CategoryType.ui, colors),
          const SizedBox(height: 8),
          _buildCategoryButton(CategoryType.coding, colors),
          const SizedBox(height: 8),
          _buildCategoryButton(CategoryType.basic, colors),
        ],
      );
    }

    return Row(
      children: <Widget>[
        Expanded(child: _buildCategoryButton(CategoryType.ui, colors)),
        const SizedBox(width: 16),
        Expanded(child: _buildCategoryButton(CategoryType.coding, colors)),
        const SizedBox(width: 16),
        Expanded(child: _buildCategoryButton(CategoryType.basic, colors)),
      ],
    );
  }

  Widget _buildCategoryButton(CategoryType category, ColorScheme colors) {
    final isSelected = _categoryType == category;

    void selectCategory() {
      if (mounted) {
        setState(() {
          _categoryType = category;
        });
      }
    }

    return Semantics(
      button: true,
      selected: isSelected,
      label: 'Select ${category.label} category',
      excludeSemantics: true,
      onTap: selectCategory,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? colors.primary : colors.surface,
          borderRadius: const BorderRadius.all(Radius.circular(24.0)),
          border: Border.all(color: colors.primary),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: colors.primary.withValues(alpha: 0.12),
            borderRadius: const BorderRadius.all(Radius.circular(24.0)),
            excludeFromSemantics: true,
            onTap: selectCategory,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 48),
              child: Center(
                child: Text(
                  category.label,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    letterSpacing: 0.27,
                    color: isSelected ? DesignCourseAppTheme.nearlyWhite : colors.primary,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(ColorScheme colors) {
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final searchHeight = 64 + (textScale - 1).clamp(0.0, 2.2).toDouble() * 24;
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.75,
            height: searchHeight,
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: DesignCourseAppTheme.cardBackground,
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(13.0),
                    bottomLeft: Radius.circular(13.0),
                    topLeft: Radius.circular(13.0),
                    topRight: Radius.circular(13.0),
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: TextFormField(
                          onChanged: (String value) {
                            setState(() {
                              _query = value.trim().toLowerCase();
                            });
                          },
                          style: TextStyle(
                            fontFamily: 'WorkSans',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: colors.onSurface,
                          ),
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: 'Search for course',
                            border: InputBorder.none,
                            helperStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: colors.onSurfaceVariant,
                            ),
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              letterSpacing: 0.2,
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 60,
                      height: searchHeight,
                      child: Icon(Icons.search, color: colors.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Expanded(child: SizedBox()),
        ],
      ),
    );
  }

  List<Category> _coursesMatchingQuery(List<Category> courses) {
    return courses
        .where((Category course) {
          final title = course.title.toLowerCase();

          return _query.isEmpty || title.contains(_query);
        })
        .toList(growable: false);
  }

  Widget _buildAppBar(ColorScheme colors) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 18, right: 18),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Choose your',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    letterSpacing: 0.2,
                    color: colors.onSurfaceVariant,
                  ),
                ),
                Text(
                  'Design Course',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    letterSpacing: 0.27,
                    color: colors.onSurface,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 60, height: 60, child: Image.asset('assets/design_course/userImage.png')),
        ],
      ),
    );
  }
}

enum CategoryType {
  ui('UI/UX'),
  coding('Coding'),
  basic('Basic UI');

  const CategoryType(this.label);

  final String label;
}

class _EmptyCourses extends StatelessWidget {
  const _EmptyCourses({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      child: Center(
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
      ),
    );
  }
}
