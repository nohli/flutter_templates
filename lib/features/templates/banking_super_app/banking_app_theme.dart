import 'package:flutter/material.dart';

import '../shared/template_theme.dart';

abstract final class BankingAppTheme {
  static const violet = Color(0xFF5537D8);
  static const acid = Color(0xFFD7FF69);
  static const coral = Color(0xFFFF8066);
  static const ice = Color(0xFF95D9FF);
  static const lightBackground = Color(0xFFF4F3F0);
  static const darkBackground = Color(0xFF0E0D12);
  static const lightSurface = Color(0xFFFFFFFF);
  static const darkSurface = Color(0xFF1A1820);
  static const fontName = 'WorkSans';
  static const displayFontName = 'BricolageGrotesque';

  static ThemeData build([Brightness brightness = Brightness.light]) {
    final dark = brightness == Brightness.dark;
    final colors = dark
        ? const ColorScheme.dark(
            primary: Color(0xFFBDAEFF),
            onPrimary: Color(0xFF261068),
            secondary: acid,
            onSecondary: Color(0xFF263000),
            surface: darkSurface,
            onSurface: Color(0xFFF7F4FB),
            onSurfaceVariant: Color(0xFFB8B3C0),
            outline: Color(0xFF918B99),
            outlineVariant: Color(0xFF38343E),
          )
        : const ColorScheme.light(
            primary: violet,
            onPrimary: Color(0xFFFFFFFF),
            secondary: Color(0xFF355900),
            onSecondary: Color(0xFFFFFFFF),
            surface: lightSurface,
            onSurface: Color(0xFF17141C),
            onSurfaceVariant: Color(0xFF66616B),
            outline: Color(0xFF77717D),
            outlineVariant: Color(0xFFE3DFE7),
          );
    return buildTemplateTheme(
      colors: colors,
      background: dark ? darkBackground : lightBackground,
      navigationIndicator: dark ? const Color(0xFF342D50) : const Color(0xFFE6E0FF),
      fontFamily: fontName,
      displayFontFamily: displayFontName,
    );
  }
}
