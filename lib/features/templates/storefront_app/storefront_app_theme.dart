import 'package:flutter/material.dart';

import '../shared/template_theme.dart';

abstract final class StorefrontAppTheme {
  static const background = Color(0xFFFBF7F0);
  static const surface = Color(0xFFFFFDF8);
  static const ink = Color(0xFF25231F);
  static const mutedInk = Color(0xFF716D65);
  static const darkBackground = Color(0xFF15130F);
  static const darkSurface = Color(0xFF211E19);
  static const darkInk = Color(0xFFF7F1E8);
  static const darkMutedInk = Color(0xFFBEB5A8);
  static const primary = Color(0xFFAD4F35);
  static const sage = Color(0xFF9DB79F);
  static const sand = Color(0xFFE8D5B5);
  static const blush = Color(0xFFE8B8A8);
  static const divider = Color(0xFFE9E1D5);
  static const fontName = 'WorkSans';
  static const displayFontName = 'InstrumentSerif';

  static ThemeData build([Brightness brightness = Brightness.light]) {
    final isDark = brightness == Brightness.dark;
    final colors = isDark
        ? const ColorScheme.dark(
            primary: Color(0xFFE7977D),
            onPrimary: Color(0xFF401509),
            primaryContainer: Color(0xFF5D2B1C),
            onPrimaryContainer: Color(0xFFFFDBCF),
            secondary: Color(0xFFB8CEB8),
            onSecondary: Color(0xFF243425),
            surface: darkSurface,
            onSurface: darkInk,
            onSurfaceVariant: darkMutedInk,
            error: Color(0xFFFFB4AB),
            onError: Color(0xFF690005),
            outline: Color(0xFF9F968B),
            outlineVariant: Color(0xFF49433B),
          )
        : const ColorScheme.light(
            primary: primary,
            onPrimary: Colors.white,
            primaryContainer: Color(0xFFF4D6CB),
            onPrimaryContainer: Color(0xFF4D1F12),
            secondary: sage,
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
      navigationIndicator: colors.primaryContainer,
      fontFamily: fontName,
      displayFontFamily: displayFontName,
    );
  }

  static const softShadow = <BoxShadow>[BoxShadow(color: Color(0x1425231F), blurRadius: 22, offset: Offset(0, 9))];
}
