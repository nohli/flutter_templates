import 'package:flutter/material.dart';

import '../shared/template_theme.dart';

abstract final class AiAssistantAppTheme {
  static const background = Color(0xFF080A12);
  static const surface = Color(0xFF121622);
  static const raisedSurface = Color(0xFF1A2030);
  static const ink = Color(0xFFF4F1FF);
  static const mutedInk = Color(0xFFA7AEC5);
  static const primary = Color(0xFF9B7BFF);
  static const lavender = Color(0xFFD3C7FF);
  static const aqua = Color(0xFF5CF1D4);
  static const pink = Color(0xFFFF70AE);
  static const divider = Color(0xFF30384C);
  static const fontName = 'WorkSans';
  static const displayFontName = 'Unbounded';
  static const panelRadius = BorderRadius.all(Radius.circular(28));
  static const controlRadius = BorderRadius.all(Radius.circular(18));

  static ThemeData build([Brightness brightness = Brightness.dark]) {
    final isDark = brightness == Brightness.dark;
    final colors = isDark
        ? const ColorScheme.dark(
            primary: primary,
            onPrimary: background,
            primaryContainer: raisedSurface,
            onPrimaryContainer: ink,
            secondary: aqua,
            onSecondary: background,
            secondaryContainer: Color(0xFF0E5048),
            onSecondaryContainer: Color(0xFFB4F4ED),
            surface: surface,
            onSurface: ink,
            error: Color(0xFFFFB4AB),
            onError: Color(0xFF690005),
            outline: mutedInk,
            outlineVariant: divider,
          )
        : const ColorScheme.light(
            primary: Color(0xFF6247D6),
            onPrimary: Colors.white,
            primaryContainer: Color(0xFFE5DFFF),
            onPrimaryContainer: Color(0xFF1A0065),
            secondary: Color(0xFF006B5F),
            onSecondary: Colors.white,
            secondaryContainer: Color(0xFF9CF2EA),
            onSecondaryContainer: Color(0xFF00201E),
            surface: Color(0xFFFFFBFF),
            onSurface: Color(0xFF171521),
            error: Color(0xFFBA1A1A),
            onError: Colors.white,
            outline: Color(0xFF706F7B),
            outlineVariant: Color(0xFFE4E1EC),
          );

    return buildTemplateTheme(
      colors: colors,
      background: isDark ? background : const Color(0xFFF3EFFB),
      navigationIndicator: isDark ? raisedSurface : const Color(0xFFE5DFFF),
      fontFamily: fontName,
      displayFontFamily: displayFontName,
    );
  }

  static const softShadow = <BoxShadow>[BoxShadow(color: Color(0x26000000), blurRadius: 28, offset: Offset(0, 12))];
}
