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

  static ThemeData build() {
    const colors = ColorScheme.dark(
      primary: primary,
      onPrimary: background,
      secondary: aqua,
      onSecondary: background,
      surface: surface,
      onSurface: ink,
      error: Color(0xFFFFB4AB),
      onError: Color(0xFF690005),
      outline: mutedInk,
      outlineVariant: divider,
    );

    return buildTemplateTheme(
      colors: colors,
      background: background,
      navigationIndicator: raisedSurface,
      fontFamily: fontName,
    );
  }

  static const softShadow = <BoxShadow>[BoxShadow(color: Color(0x52000000), blurRadius: 26, offset: Offset(0, 10))];
}
