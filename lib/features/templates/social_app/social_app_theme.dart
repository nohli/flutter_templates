import 'package:flutter/material.dart';

import '../shared/template_theme.dart';

abstract final class SocialAppTheme {
  static const background = Color(0xFFF4EEDB);
  static const surface = Color(0xFFFFFBED);
  static const ink = Color(0xFF171611);
  static const mutedInk = Color(0xFF676153);
  static const primary = Color(0xFF3355FF);
  static const lavender = Color(0xFFC9CBFF);
  static const coral = Color(0xFFFF5C7A);
  static const mint = Color(0xFF7DE36B);
  static const amber = Color(0xFFFFC936);
  static const divider = Color(0xFFD5CDB7);
  static const fontName = 'BricolageGrotesque';
  static const displayFontName = 'Anybody';

  static ThemeData build([Brightness brightness = Brightness.light]) {
    final isDark = brightness == Brightness.dark;
    final colors = isDark
        ? const ColorScheme.dark(
            primary: Color(0xFF91A1FF),
            onPrimary: Color(0xFF00146D),
            primaryContainer: Color(0xFF2038C3),
            onPrimaryContainer: Color(0xFFDDE1FF),
            secondary: Color(0xFFFF7F98),
            onSecondary: Color(0xFF5D001D),
            secondaryContainer: Color(0xFF81002C),
            onSecondaryContainer: Color(0xFFFFD9E0),
            surface: Color(0xFF24221B),
            onSurface: Color(0xFFF3EEDC),
            error: Color(0xFFFFB4AB),
            onError: Color(0xFF690005),
            outline: Color(0xFFA9A18D),
            outlineVariant: Color(0xFF514D40),
          )
        : const ColorScheme.light(
            primary: primary,
            onPrimary: Colors.white,
            primaryContainer: Color(0xFFDDE1FF),
            onPrimaryContainer: ink,
            secondary: coral,
            onSecondary: ink,
            secondaryContainer: Color(0xFFFFD9E0),
            onSecondaryContainer: ink,
            surface: surface,
            onSurface: ink,
            error: Color(0xFFBA1A1A),
            onError: Colors.white,
            outline: mutedInk,
            outlineVariant: divider,
          );

    return buildTemplateTheme(
      colors: colors,
      background: isDark ? const Color(0xFF13120F) : background,
      navigationIndicator: isDark ? const Color(0xFF2038C3) : const Color(0xFFDDE1FF),
      fontFamily: fontName,
      displayFontFamily: displayFontName,
    );
  }

  static const softShadow = <BoxShadow>[BoxShadow(color: Color(0x24171611), blurRadius: 0, offset: Offset(6, 6))];
}
