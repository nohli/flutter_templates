import 'package:flutter/material.dart';

import '../shared/template_theme.dart';

abstract final class PodcastAppTheme {
  static const background = Color(0xFFF6F2EA);
  static const surface = Color(0xFFFFFFFF);
  static const ink = Color(0xFF171C33);
  static const mutedInk = Color(0xFF686B78);
  static const primary = Color(0xFFB64B5B);
  static const cobalt = Color(0xFF5C4DCC);
  static const blush = Color(0xFFF3CED2);
  static const sky = Color(0xFF317A91);
  static const sage = Color(0xFF4F7956);
  static const divider = Color(0xFFE6E0D7);
  static const fontName = 'WorkSans';

  static ThemeData build() {
    const colors = ColorScheme.light(
      primary: primary,
      onPrimary: Colors.white,
      secondary: cobalt,
      onSecondary: Colors.white,
      surface: surface,
      onSurface: ink,
      error: Color(0xFFBA1A1A),
      onError: Colors.white,
      outline: mutedInk,
      outlineVariant: divider,
    );

    return buildTemplateTheme(colors: colors, background: background, navigationIndicator: blush, fontFamily: fontName);
  }
}
