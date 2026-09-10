import 'package:flutter/material.dart';

abstract final class SmartHomeAppTheme {
  static const background = Color(0xFFF1F5F3);
  static const surface = Color(0xFFFFFFFF);
  static const ink = Color(0xFF18312D);
  static const mutedInk = Color(0xFF5C6F69);
  static const primary = Color(0xFF087B6A);
  static const deepGreen = Color(0xFF124E47);
  static const blue = Color(0xFF4865D9);
  static const mint = Color(0xFFCDE8DF);
  static const sky = Color(0xFFD8E4FA);
  static const amber = Color(0xFFF1D59B);
  static const divider = Color(0xFFDDE7E3);
  static const fontName = 'WorkSans';

  static ThemeData build() {
    const colors = ColorScheme.light(
      primary: primary,
      onPrimary: Colors.white,
      secondary: blue,
      onSecondary: Colors.white,
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

  static const softShadow = <BoxShadow>[BoxShadow(color: Color(0x1218312D), blurRadius: 22, offset: Offset(0, 9))];
}
