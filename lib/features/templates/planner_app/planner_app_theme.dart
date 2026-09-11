import 'package:flutter/material.dart';

import '../shared/template_theme.dart';

abstract final class PlannerAppTheme {
  static const background = Color(0xFFF1F4FA);
  static const surface = Color(0xFFFFFFFF);
  static const ink = Color(0xFF15213D);
  static const mutedInk = Color(0xFF66718B);
  static const primary = Color(0xFF405CF5);
  static const navy = Color(0xFF172653);
  static const lime = Color(0xFFCFEA6B);
  static const sky = Color(0xFFCBE6FF);
  static const peach = Color(0xFFFFD5C5);
  static const divider = Color(0xFFE2E7F0);
  static const fontName = 'Syne';
  static const displayFontName = 'Syne';

  static ThemeData build([Brightness brightness = Brightness.light]) {
    final isDark = brightness == Brightness.dark;
    final colors = isDark
        ? const ColorScheme.dark(
            primary: Color(0xFF9EADFF),
            onPrimary: Color(0xFF0D1E68),
            secondary: lime,
            onSecondary: Color(0xFF293400),
            surface: Color(0xFF1A2030),
            onSurface: Color(0xFFF1F3FA),
            error: Color(0xFFFFB4AB),
            onError: Color(0xFF690005),
            outline: Color(0xFF929AB0),
            outlineVariant: Color(0xFF3B4355),
          )
        : const ColorScheme.light(
            primary: primary,
            onPrimary: Colors.white,
            secondary: lime,
            onSecondary: ink,
            surface: surface,
            onSurface: ink,
            error: Color(0xFFBA1A1A),
            onError: Colors.white,
            outline: mutedInk,
            outlineVariant: divider,
          );

    return buildTemplateTheme(
      colors: colors,
      background: isDark ? const Color(0xFF101522) : background,
      navigationIndicator: isDark ? const Color(0xFF34416B) : lime,
      fontFamily: fontName,
      displayFontFamily: displayFontName,
    );
  }

  static const softShadow = <BoxShadow>[BoxShadow(color: Color(0x1215213D), blurRadius: 20, offset: Offset(0, 8))];
}
