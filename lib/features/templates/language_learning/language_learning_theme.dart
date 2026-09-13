import 'package:flutter/material.dart';

import '../shared/template_theme.dart';

abstract final class LanguageLearningTheme {
  static const primary = Color(0xFF25B97A);
  static const sky = Color(0xFF45A7FF);
  static const mango = Color(0xFFFFC83D);
  static const coral = Color(0xFFFF6B62);
  static const lightBackground = Color(0xFFFFFBF1);
  static const darkBackground = Color(0xFF111813);
  static const lightSurface = Color(0xFFFFFFFF);
  static const darkSurface = Color(0xFF1A251E);
  static const fontName = 'WorkSans';
  static const displayFontName = 'BricolageGrotesque';

  static ThemeData build([Brightness brightness = Brightness.light]) {
    final dark = brightness == Brightness.dark;
    final colors = dark
        ? const ColorScheme.dark(
            primary: Color(0xFF60DCA0),
            onPrimary: Color(0xFF062718),
            secondary: Color(0xFF80C7FF),
            onSecondary: Color(0xFF071D2D),
            surface: darkSurface,
            onSurface: Color(0xFFF4FAF5),
            onSurfaceVariant: Color(0xFFB6C5BA),
            outline: Color(0xFF829087),
            outlineVariant: Color(0xFF34443A),
          )
        : const ColorScheme.light(
            primary: primary,
            onPrimary: Color(0xFF062D1B),
            secondary: sky,
            onSecondary: Color(0xFFFFFFFF),
            surface: lightSurface,
            onSurface: Color(0xFF173126),
            onSurfaceVariant: Color(0xFF607168),
            outline: Color(0xFF788A80),
            outlineVariant: Color(0xFFDDE8E0),
          );
    return buildTemplateTheme(
      colors: colors,
      background: dark ? darkBackground : lightBackground,
      navigationIndicator: dark ? const Color(0xFF284B3A) : const Color(0xFFDDF7E9),
      fontFamily: fontName,
      displayFontFamily: displayFontName,
    );
  }
}
