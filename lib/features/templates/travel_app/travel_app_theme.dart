import 'package:flutter/material.dart';

import '../shared/template_theme.dart';

abstract final class TravelAppTheme {
  static const background = Color(0xFFF2ECD8);
  static const surface = Color(0xFFFFF9E9);
  static const ink = Color(0xFF17352F);
  static const mutedInk = Color(0xFF61716A);
  static const primary = Color(0xFFC93C22);
  static const ocean = Color(0xFF0B716C);
  static const seaGlass = Color(0xFFBDE2D5);
  static const sun = Color(0xFFF4CF45);
  static const coral = Color(0xFFF07A58);
  static const fontName = 'WorkSans';

  static ThemeData build([Brightness brightness = Brightness.light]) {
    final isDark = brightness == Brightness.dark;
    final colors = isDark
        ? const ColorScheme.dark(
            primary: Color(0xFFFFB5A4),
            onPrimary: Color(0xFF5F140A),
            primaryContainer: Color(0xFF7F291D),
            onPrimaryContainer: Color(0xFFFFDAD3),
            secondary: Color(0xFF80D5D2),
            onSecondary: Color(0xFF003736),
            secondaryContainer: Color(0xFF00504F),
            onSecondaryContainer: Color(0xFF9CF2EE),
            surface: Color(0xFF1B2925),
            onSurface: Color(0xFFE5F1EF),
            error: Color(0xFFFFB4AB),
            onError: Color(0xFF690005),
            outline: Color(0xFF91A4A2),
            outlineVariant: Color(0xFF3E504F),
          )
        : const ColorScheme.light(
            primary: primary,
            onPrimary: Colors.white,
            primaryContainer: Color(0xFFFFDAD3),
            onPrimaryContainer: Color(0xFF3D0702),
            secondary: ocean,
            onSecondary: Colors.white,
            secondaryContainer: seaGlass,
            onSecondaryContainer: ink,
            surface: surface,
            onSurface: ink,
            error: Color(0xFFBA1A1A),
            onError: Colors.white,
            outline: mutedInk,
            outlineVariant: Color(0xFFD5DFDC),
          );

    return buildTemplateTheme(
      colors: colors,
      background: isDark ? const Color(0xFF101A17) : background,
      navigationIndicator: isDark ? const Color(0xFF00504F) : seaGlass,
      fontFamily: fontName,
    );
  }
}
