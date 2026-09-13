import 'package:flutter/material.dart';

import '../shared/template_theme.dart';

abstract final class SocialFeedTheme {
  static const accent = Color(0xFFFF4F7A);
  static const electricBlue = Color(0xFF4A7DFF);
  static const lightBackground = Color(0xFFF8F7F3);
  static const darkBackground = Color(0xFF090A0C);
  static const lightSurface = Color(0xFFFFFFFF);
  static const darkSurface = Color(0xFF15171B);
  static const fontName = 'WorkSans';
  static const displayFontName = 'SpaceGrotesk';

  static ThemeData build([Brightness brightness = Brightness.light]) {
    final dark = brightness == Brightness.dark;
    final colors = dark
        ? const ColorScheme.dark(
            primary: Color(0xFFFF6C91),
            onPrimary: Color(0xFF3A0016),
            secondary: Color(0xFF9CB6FF),
            onSecondary: Color(0xFF071842),
            surface: darkSurface,
            onSurface: Color(0xFFF7F7F4),
            onSurfaceVariant: Color(0xFFAEB1BA),
            outline: Color(0xFF8C9099),
            outlineVariant: Color(0xFF303238),
          )
        : const ColorScheme.light(
            primary: accent,
            onPrimary: Color(0xFF3D0017),
            secondary: electricBlue,
            onSecondary: Color(0xFFFFFFFF),
            surface: lightSurface,
            onSurface: Color(0xFF141519),
            onSurfaceVariant: Color(0xFF62656E),
            outline: Color(0xFF747780),
            outlineVariant: Color(0xFFE2E2DE),
          );
    return buildTemplateTheme(
      colors: colors,
      background: dark ? darkBackground : lightBackground,
      navigationIndicator: dark ? const Color(0xFF34232B) : const Color(0xFFFFE1E9),
      fontFamily: fontName,
      displayFontFamily: displayFontName,
    );
  }
}
