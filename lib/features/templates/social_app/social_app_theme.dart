import 'package:flutter/material.dart';

import '../shared/template_theme.dart';

abstract final class SocialAppTheme {
  static const background = Color(0xFFF7F4FB);
  static const surface = Color(0xFFFFFFFF);
  static const ink = Color(0xFF211D30);
  static const mutedInk = Color(0xFF746E82);
  static const primary = Color(0xFF6C5CE7);
  static const lavender = Color(0xFFE8E2FF);
  static const coral = Color(0xFFFF8B88);
  static const mint = Color(0xFF79D9C8);
  static const amber = Color(0xFFFFD27A);
  static const divider = Color(0xFFE8E3EE);
  static const fontName = 'WorkSans';

  static ThemeData build() {
    const colors = ColorScheme.light(
      primary: primary,
      onPrimary: Colors.white,
      secondary: mint,
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
      background: background,
      navigationIndicator: lavender,
      fontFamily: fontName,
    );
  }

  static const softShadow = <BoxShadow>[BoxShadow(color: Color(0x14211D30), blurRadius: 22, offset: Offset(0, 9))];
}
