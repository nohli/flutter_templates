import 'package:flutter/material.dart';

import '../shared/template_theme.dart';

abstract final class ChannelMessengerTheme {
  static const blue = Color(0xFF1677D2);
  static const cyan = Color(0xFF66D6F2);
  static const amber = Color(0xFFFFC857);
  static const lightBackground = Color(0xFFF3F8FC);
  static const darkBackground = Color(0xFF0D1620);
  static const lightSurface = Color(0xFFFFFFFF);
  static const darkSurface = Color(0xFF172330);
  static const fontName = 'WorkSans';
  static const displayFontName = 'SpaceGrotesk';

  static ThemeData build([Brightness brightness = Brightness.light]) {
    final dark = brightness == Brightness.dark;
    final colors = dark
        ? const ColorScheme.dark(
            primary: Color(0xFF72BFFF),
            onPrimary: Color(0xFF002D4F),
            secondary: cyan,
            onSecondary: Color(0xFF003642),
            surface: darkSurface,
            onSurface: Color(0xFFF3F8FC),
            onSurfaceVariant: Color(0xFFAFC1D0),
            outline: Color(0xFF8B9CA9),
            outlineVariant: Color(0xFF30404E),
          )
        : const ColorScheme.light(
            primary: blue,
            onPrimary: Color(0xFFFFFFFF),
            secondary: Color(0xFF00677C),
            onSecondary: Color(0xFFFFFFFF),
            surface: lightSurface,
            onSurface: Color(0xFF172936),
            onSurfaceVariant: Color(0xFF617582),
            outline: Color(0xFF718591),
            outlineVariant: Color(0xFFD9E5EC),
          );
    return buildTemplateTheme(
      colors: colors,
      background: dark ? darkBackground : lightBackground,
      navigationIndicator: dark ? const Color(0xFF23445E) : const Color(0xFFD8EEFF),
      fontFamily: fontName,
      displayFontFamily: displayFontName,
    );
  }
}
