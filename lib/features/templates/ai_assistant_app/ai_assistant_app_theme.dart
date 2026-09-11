import 'package:flutter/material.dart';

import '../shared/template_theme.dart';

abstract final class AiAssistantAppTheme {
  static const background = Color(0xFF0C1022);
  static const surface = Color(0xFF171D34);
  static const raisedSurface = Color(0xFF202744);
  static const ink = Color(0xFFF7F8FF);
  static const mutedInk = Color(0xFFA7AEC7);
  static const primary = Color(0xFF8C7CFF);
  static const lavender = Color(0xFFCDC5FF);
  static const aqua = Color(0xFF66E0D2);
  static const pink = Color(0xFFFF8FBB);
  static const divider = Color(0xFF2B3352);
  static const fontName = 'WorkSans';

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
            secondaryContainer: Color(0xFF124D52),
            onSecondaryContainer: Color(0xFFB4F4ED),
            surface: surface,
            onSurface: ink,
            error: Color(0xFFFFB4AB),
            onError: Color(0xFF690005),
            outline: mutedInk,
            outlineVariant: divider,
          )
        : const ColorScheme.light(
            primary: Color(0xFF5946C7),
            onPrimary: Colors.white,
            primaryContainer: Color(0xFFE5DFFF),
            onPrimaryContainer: Color(0xFF1A0065),
            secondary: Color(0xFF006A65),
            onSecondary: Colors.white,
            secondaryContainer: Color(0xFF9CF2EA),
            onSecondaryContainer: Color(0xFF00201E),
            surface: Color(0xFFFFFBFF),
            onSurface: Color(0xFF1B1B22),
            error: Color(0xFFBA1A1A),
            onError: Colors.white,
            outline: Color(0xFF706F7B),
            outlineVariant: Color(0xFFE4E1EC),
          );

    return buildTemplateTheme(
      colors: colors,
      background: isDark ? background : const Color(0xFFF7F5FF),
      navigationIndicator: isDark ? raisedSurface : const Color(0xFFE5DFFF),
      fontFamily: fontName,
    );
  }

  static const softShadow = <BoxShadow>[BoxShadow(color: Color(0x52000000), blurRadius: 26, offset: Offset(0, 10))];
}
