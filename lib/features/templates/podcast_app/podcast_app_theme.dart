import 'package:flutter/material.dart';

import '../shared/template_theme.dart';

abstract final class PodcastAppTheme {
  static const background = Color(0xFFF7F0D7);
  static const surface = Color(0xFFFFFCF0);
  static const ink = Color(0xFF191711);
  static const mutedInk = Color(0xFF696354);
  static const primary = Color(0xFFFF5C35);
  static const cobalt = Color(0xFF5747F5);
  static const signal = Color(0xFFF3DD43);
  static const sky = Color(0xFF0C7892);
  static const sage = Color(0xFF337252);
  static const divider = Color(0xFFD8CFB1);
  static const fontName = 'SpaceGrotesk';
  static const displayFontName = 'ArchivoBlack';

  static ThemeData build([Brightness brightness = Brightness.light]) {
    final isDark = brightness == Brightness.dark;
    final colors = isDark
        ? const ColorScheme.dark(
            primary: Color(0xFFFF795B),
            onPrimary: Color(0xFF341007),
            primaryContainer: Color(0xFF6B281A),
            onPrimaryContainer: Color(0xFFFFDAD1),
            secondary: Color(0xFFF3DD43),
            onSecondary: Color(0xFF201C00),
            secondaryContainer: Color(0xFF514900),
            onSecondaryContainer: Color(0xFFFFF1A8),
            surface: Color(0xFF211F19),
            onSurface: Color(0xFFF4EFDF),
            error: Color(0xFFFFB4AB),
            onError: Color(0xFF690005),
            outline: Color(0xFFA8A08A),
            outlineVariant: Color(0xFF514C3F),
          )
        : const ColorScheme.light(
            primary: primary,
            onPrimary: ink,
            primaryContainer: Color(0xFFFFD8CA),
            onPrimaryContainer: ink,
            secondary: ink,
            onSecondary: signal,
            secondaryContainer: signal,
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
      background: isDark ? const Color(0xFF12110E) : background,
      navigationIndicator: isDark ? const Color(0xFF5B2B20) : const Color(0xFFFFD8CA),
      fontFamily: fontName,
      displayFontFamily: displayFontName,
    );
  }
}
