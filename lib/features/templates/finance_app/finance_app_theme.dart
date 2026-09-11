import 'package:flutter/material.dart';

import '../shared/template_theme.dart';

abstract final class FinanceAppTheme {
  static const background = Color(0xFFF6F4EE);
  static const surface = Color(0xFFFFFEFA);
  static const ink = Color(0xFF182033);
  static const mutedInk = Color(0xFF687084);
  static const darkBackground = Color(0xFF0E1118);
  static const darkSurface = Color(0xFF191E28);
  static const darkInk = Color(0xFFF4F6FB);
  static const darkMutedInk = Color(0xFFAEB6C6);
  static const primary = Color(0xFF5364F4);
  static const primaryDark = Color(0xFF27368F);
  static const mint = Color(0xFF63D7B0);
  static const coral = Color(0xFFFF8D7A);
  static const amber = Color(0xFFFFC766);
  static const lavender = Color(0xFFE7E9FF);
  static const divider = Color(0xFFE9E6DE);
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
