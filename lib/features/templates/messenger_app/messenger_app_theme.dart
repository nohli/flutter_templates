import 'package:flutter/material.dart';

abstract final class MessengerAppTheme {
  static const background = Color(0xFFF5F3FA);
  static const surface = Color(0xFFFFFFFF);
  static const ink = Color(0xFF201D2D);
  static const mutedInk = Color(0xFF716D80);
  static const primary = Color(0xFF7357D9);
  static const violet = Color(0xFF49349B);
  static const lavender = Color(0xFFE6DFFF);
  static const aqua = Color(0xFFAFE8DE);
  static const rose = Color(0xFFFFCED9);
  static const gold = Color(0xFFFFDF9E);
  static const divider = Color(0xFFE8E4EF);
  static const fontName = 'WorkSans';

  static ThemeData build() {
    const colors = ColorScheme.light(
      primary: primary,
      onPrimary: Colors.white,
      secondary: aqua,
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

  static const softShadow = <BoxShadow>[BoxShadow(color: Color(0x12201D2D), blurRadius: 20, offset: Offset(0, 8))];
}
