import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:templates/features/templates/shared/template_theme.dart';

void main() {
  test('template theme applies the shared visual foundation', () {
    const colors = ColorScheme.light(
      primary: Color(0xFF405CF5),
      surface: Color(0xFFFFFFFF),
      onSurface: Color(0xFF15213D),
    );
    const background = Color(0xFFF1F4FA);
    const indicator = Color(0xFFCFEA6B);

    final theme = buildTemplateTheme(
      colors: colors,
      background: background,
      navigationIndicator: indicator,
      fontFamily: 'WorkSans',
    );

    expect(theme.colorScheme, colors);
    expect(theme.scaffoldBackgroundColor, background);
    expect(theme.useMaterial3, isTrue);
    expect(theme.textTheme.bodyMedium?.fontFamily, 'WorkSans');
    expect(theme.appBarTheme.surfaceTintColor, Colors.transparent);
    expect(theme.appBarTheme.scrolledUnderElevation, 0);
    expect(theme.cardTheme.margin, EdgeInsets.zero);
    expect(theme.inputDecorationTheme.filled, isTrue);
    expect(theme.inputDecorationTheme.fillColor, colors.surface);
    expect(theme.navigationBarTheme.indicatorColor, indicator);
    expect(theme.snackBarTheme.behavior, SnackBarBehavior.floating);
  });
}
