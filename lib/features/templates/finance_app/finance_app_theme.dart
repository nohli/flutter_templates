import 'package:flutter/material.dart';

import '../shared/template_theme.dart';

abstract final class FinanceAppTheme {
  static const background = Color(0xFFF1EFE8);
  static const surface = Color(0xFFFFFEF9);
  static const ink = Color(0xFF0B1020);
  static const mutedInk = Color(0xFF666D7C);
  static const darkBackground = Color(0xFF05080D);
  static const darkSurface = Color(0xFF0D121C);
  static const darkInk = Color(0xFFF8FAFF);
  static const darkMutedInk = Color(0xFFAAB3C2);
  static const primary = Color(0xFF5367FF);
  static const primaryDark = Color(0xFF101936);
  static const mint = Color(0xFF6EE7B7);
  static const coral = Color(0xFFFF7B6B);
  static const amber = Color(0xFFFFC857);
  static const lavender = Color(0xFFE3E6FF);
  static const divider = Color(0xFFE2E0D8);
  static const fontName = 'Roboto';

  static ThemeData build([Brightness brightness = Brightness.light]) {
    final isDark = brightness == Brightness.dark;
    final colors = isDark
        ? const ColorScheme.dark(
            primary: Color(0xFF9BA7FF),
            onPrimary: Color(0xFF111A58),
            secondary: mint,
            onSecondary: darkBackground,
            surface: darkSurface,
            onSurface: darkInk,
            onSurfaceVariant: darkMutedInk,
            error: Color(0xFFFFB4AB),
            onError: Color(0xFF690005),
            outline: Color(0xFF949CAD),
            outlineVariant: Color(0xFF343B49),
          )
        : const ColorScheme.light(
            primary: primary,
            onPrimary: Colors.white,
            secondary: mint,
            onSecondary: ink,
            surface: surface,
            onSurface: ink,
            onSurfaceVariant: mutedInk,
            error: Color(0xFFBA1A1A),
            onError: Colors.white,
            outline: mutedInk,
            outlineVariant: divider,
          );

    return buildTemplateTheme(
      colors: colors,
      background: isDark ? darkBackground : background,
      navigationIndicator: isDark ? const Color(0xFF29315A) : lavender,
      fontFamily: fontName,
    );
  }

  static const softShadow = <BoxShadow>[BoxShadow(color: Color(0x14182033), blurRadius: 24, offset: Offset(0, 10))];
}
