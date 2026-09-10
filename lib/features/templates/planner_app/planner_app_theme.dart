import 'package:flutter/material.dart';

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
  static const fontName = 'WorkSans';

  static ThemeData build() {
    const colors = ColorScheme.light(
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

    return ThemeData(
      colorScheme: colors,
      fontFamily: fontName,
      scaffoldBackgroundColor: background,
      useMaterial3: true,
    );
  }

  static const softShadow = <BoxShadow>[BoxShadow(color: Color(0x1215213D), blurRadius: 20, offset: Offset(0, 8))];
}
