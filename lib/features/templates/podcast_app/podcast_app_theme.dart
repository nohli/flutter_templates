import 'package:flutter/material.dart';

import '../shared/template_theme.dart';

abstract final class PodcastAppTheme {
  static const background = Color(0xFFF6F2EA);
  static const surface = Color(0xFFFFFFFF);
  static const ink = Color(0xFF171C33);
  static const mutedInk = Color(0xFF686B78);
  static const primary = Color(0xFFB64B5B);
  static const cobalt = Color(0xFF5C4DCC);
  static const blush = Color(0xFFF3CED2);
  static const sky = Color(0xFF317A91);
  static const sage = Color(0xFF4F7956);
  static const divider = Color(0xFFE6E0D7);
  static const fontName = 'WorkSans';

  static ThemeData build([Brightness brightness = Brightness.light]) {
    final isDark = brightness == Brightness.dark;
    final colors = isDark
        ? const ColorScheme.dark(
            primary: Color(0xFFFFAEB8),
            onPrimary: Color(0xFF65001E),
            primaryContainer: Color(0xFF7D2639),
            onPrimaryContainer: Color(0xFFFFDADD),
            secondary: Color(0xFFC6BCFF),
            onSecondary: Color(0xFF2D207C),
            secondaryContainer: Color(0xFF443795),
            onSecondaryContainer: Color(0xFFE5DEFF),
            surface: Color(0xFF201F27),
            onSurface: Color(0xFFF0EDF5),
            error: Color(0xFFFFB4AB),
            onError: Color(0xFF690005),
            outline: Color(0xFF9B97A5),
            outlineVariant: Color(0xFF48454F),
          )
        : const ColorScheme.light(
            primary: primary,
            onPrimary: Colors.white,
            primaryContainer: blush,
            onPrimaryContainer: ink,
            secondary: cobalt,
            onSecondary: Colors.white,
            secondaryContainer: Color(0xFFE5DFFF),
            onSecondaryContainer: ink,
            surface: surface,
            onSurface: ink,
            error: Color(0xFFBA1A1A),
            onError: Colors.white,
            outline: mutedInk,
            outlineVariant: divider,
          );

    return buildTemplateTheme(
      colors: colors,
      background: isDark ? const Color(0xFF14131A) : background,
      navigationIndicator: isDark ? const Color(0xFF533240) : blush,
      fontFamily: fontName,
    );
  }
}
