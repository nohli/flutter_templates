import 'package:flutter/material.dart';

import '../shared/template_theme.dart';

abstract final class StorefrontAppTheme {
  static const background = Color(0xFFFBF7F0);
  static const surface = Color(0xFFFFFDF8);
  static const ink = Color(0xFF25231F);
  static const mutedInk = Color(0xFF716D65);
  static const primary = Color(0xFFAD4F35);
  static const sage = Color(0xFF9DB79F);
  static const sand = Color(0xFFE8D5B5);
  static const blush = Color(0xFFE8B8A8);
  static const divider = Color(0xFFE9E1D5);
  static const fontName = 'WorkSans';

  static ThemeData build() {
    const colors = ColorScheme.light(
      primary: primary,
      onPrimary: Colors.white,
      secondary: sage,
      onSecondary: ink,
      surface: surface,
      onSurface: ink,
      error: Color(0xFFBA1A1A),
      onError: Colors.white,
      outline: mutedInk,
      outlineVariant: divider,
    );

    return buildTemplateTheme(colors: colors, background: background, navigationIndicator: blush, fontFamily: fontName);
  }

  static const softShadow = <BoxShadow>[BoxShadow(color: Color(0x1425231F), blurRadius: 22, offset: Offset(0, 9))];
}
