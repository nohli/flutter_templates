import 'package:flutter/material.dart';

import '../shared/template_theme.dart';

abstract final class SocialAppTheme {
  static const background = Color(0xFFF7F4FB);
  static const surface = Color(0xFFFFFFFF);
  static const ink = Color(0xFF211D30);
  static const mutedInk = Color(0xFF746E82);
  static const primary = Color(0xFF6C5CE7);
  static const lavender = Color(0xFFE8E2FF);
  static const coral = Color(0xFFFF8B88);
  static const mint = Color(0xFF79D9C8);
  static const amber = Color(0xFFFFD27A);
  static const divider = Color(0xFFE8E3EE);
  static const fontName = 'WorkSans';

  static ThemeData build([Brightness brightness = Brightness.light]) {
    final isDark = brightness == Brightness.dark;
    final colors = isDark
        ? const ColorScheme.dark(
            primary: Color(0xFFC8BFFF),
            onPrimary: Color(0xFF2D2178),
            primaryContainer: Color(0xFF443795),
            onPrimaryContainer: Color(0xFFE6DEFF),
            secondary: Color(0xFF8FE8D7),
            onSecondary: Color(0xFF00382F),
            secondaryContainer: Color(0xFF125047),
            onSecondaryContainer: Color(0xFFAAF5E5),
            surface: Color(0xFF211E29),
            onSurface: Color(0xFFF0ECF5),
            error: Color(0xFFFFB4AB),
            onError: Color(0xFF690005),
            outline: Color(0xFF9A94A6),
            outlineVariant: Color(0xFF494451),
          )
        : const ColorScheme.light(
            primary: primary,
            onPrimary: Colors.white,
            primaryContainer: lavender,
            onPrimaryContainer: ink,
            secondary: mint,
            onSecondary: ink,
            secondaryContainer: Color(0xFFD6F5EF),
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
      background: isDark ? const Color(0xFF15131B) : background,
      navigationIndicator: isDark ? const Color(0xFF443795) : lavender,
      fontFamily: fontName,
    );
  }

  static const softShadow = <BoxShadow>[BoxShadow(color: Color(0x14211D30), blurRadius: 22, offset: Offset(0, 9))];
}
