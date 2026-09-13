import 'package:flutter/material.dart';

import '../shared/template_theme.dart';

abstract final class PrivateMessengerTheme {
  static const evergreen = Color(0xFF087A63);
  static const mint = Color(0xFF8FE3C1);
  static const peach = Color(0xFFFFB48A);
  static const lilac = Color(0xFFC8B6FF);
  static const lightBackground = Color(0xFFFFF8ED);
  static const darkBackground = Color(0xFF101714);
  static const lightSurface = Color(0xFFFFFFFF);
  static const darkSurface = Color(0xFF1A2420);
  static const fontName = 'WorkSans';
  static const displayFontName = 'Fraunces';

  static ThemeData build([Brightness brightness = Brightness.light]) {
    final dark = brightness == Brightness.dark;
    final colors = dark
        ? const ColorScheme.dark(
            primary: Color(0xFF85D9B8),
            onPrimary: Color(0xFF00382B),
            secondary: Color(0xFFFFC9AA),
            onSecondary: Color(0xFF512300),
            surface: darkSurface,
            onSurface: Color(0xFFF4FBF7),
            onSurfaceVariant: Color(0xFFB4C5BD),
            outline: Color(0xFF8C9E95),
            outlineVariant: Color(0xFF34463E),
          )
        : const ColorScheme.light(
            primary: evergreen,
            onPrimary: Color(0xFFFFFFFF),
            secondary: Color(0xFF8B3900),
            onSecondary: Color(0xFFFFFFFF),
            surface: lightSurface,
            onSurface: Color(0xFF173129),
            onSurfaceVariant: Color(0xFF64766E),
            outline: Color(0xFF74877E),
            outlineVariant: Color(0xFFDCE8E1),
          );
    return buildTemplateTheme(
      colors: colors,
      background: dark ? darkBackground : lightBackground,
      navigationIndicator: dark ? const Color(0xFF264C3E) : const Color(0xFFD8F4E7),
      fontFamily: fontName,
      displayFontFamily: displayFontName,
    );
  }
}
