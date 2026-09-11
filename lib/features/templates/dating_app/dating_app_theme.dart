import 'package:flutter/material.dart';

import '../shared/template_theme.dart';

abstract final class DatingAppTheme {
  static const background = Color(0xFF0B090D);
  static const surface = Color(0xFF1D181F);
  static const raisedSurface = Color(0xFF2A222D);
  static const ink = Color(0xFFFFF6ED);
  static const mutedInk = Color(0xFFCBBEC8);
  static const primary = Color(0xFFFF668F);
  static const lavender = Color(0xFFC6A7FF);
  static const mint = Color(0xFF76E6D1);
  static const coral = Color(0xFFFF7B61);
  static const sun = Color(0xFFFFD449);
  static const fontName = 'WorkSans';

  static ThemeData build([Brightness brightness = Brightness.dark]) {
    final isDark = brightness == Brightness.dark;
    final colors = isDark
        ? const ColorScheme.dark(
            primary: primary,
            onPrimary: Color(0xFF56002B),
            primaryContainer: Color(0xFF6F1F48),
            onPrimaryContainer: Color(0xFFFFD8E5),
            secondary: lavender,
            onSecondary: Color(0xFF2E176E),
            secondaryContainer: Color(0xFF453085),
            onSecondaryContainer: Color(0xFFE8DEFF),
            surface: surface,
            onSurface: ink,
            error: Color(0xFFFFB4AB),
            onError: Color(0xFF690005),
            outline: mutedInk,
            outlineVariant: Color(0xFF4D4054),
          )
        : const ColorScheme.light(
            primary: Color(0xFFB52C5B),
            onPrimary: Colors.white,
            primaryContainer: Color(0xFFFFD9E4),
            onPrimaryContainer: Color(0xFF3F001E),
            secondary: Color(0xFF6047A9),
            onSecondary: Colors.white,
            secondaryContainer: Color(0xFFE8DEFF),
            onSecondaryContainer: Color(0xFF1D0061),
            surface: Color(0xFFFFFAF2),
            onSurface: Color(0xFF21181D),
            error: Color(0xFFBA1A1A),
            onError: Colors.white,
            outline: Color(0xFF7E7078),
            outlineVariant: Color(0xFFEEDFE5),
          );

    return buildTemplateTheme(
      colors: colors,
      background: isDark ? background : const Color(0xFFFFF3EA),
      navigationIndicator: isDark ? raisedSurface : const Color(0xFFFFD9E4),
      fontFamily: fontName,
    );
  }
}
