import 'package:flutter/material.dart';

class HotelAppTheme {
  static const seedColor = Color(0xFF54D3C2);
  static const actionColor = Color(0xFF006A60);
  static const rangeColor = Color(0xFFBBEDE7);

  static TextTheme _buildTextTheme(TextTheme base) {
    const fontName = 'WorkSans';
    return base.copyWith(
      displayLarge: base.displayLarge?.copyWith(fontFamily: fontName),
      displayMedium: base.displayMedium?.copyWith(fontFamily: fontName),
      displaySmall: base.displaySmall?.copyWith(fontFamily: fontName),
      headlineMedium: base.headlineMedium?.copyWith(fontFamily: fontName),
      headlineSmall: base.headlineSmall?.copyWith(fontFamily: fontName),
      titleLarge: base.titleLarge?.copyWith(fontFamily: fontName),
      labelLarge: base.labelLarge?.copyWith(fontFamily: fontName),
      bodySmall: base.bodySmall?.copyWith(fontFamily: fontName),
      bodyLarge: base.bodyLarge?.copyWith(fontFamily: fontName),
      bodyMedium: base.bodyMedium?.copyWith(fontFamily: fontName),
      titleMedium: base.titleMedium?.copyWith(fontFamily: fontName),
      titleSmall: base.titleSmall?.copyWith(fontFamily: fontName),
      labelSmall: base.labelSmall?.copyWith(fontFamily: fontName),
    );
  }

  static ThemeData build() {
    const colorScheme = ColorScheme.light(
      primary: seedColor,
      onPrimary: Color(0xFF17262A),
      primaryContainer: rangeColor,
      onPrimaryContainer: Color(0xFF17262A),
      secondary: actionColor,
      onSecondary: Colors.white,
      surface: Colors.white,
      onSurface: Color(0xFF17262A),
      onSurfaceVariant: Color(0xFF4A6572),
      outline: Color(0xFF3A5160),
      outlineVariant: Color(0xFFE0E0E0),
      error: Color(0xFFB00020),
      onError: Colors.white,
    );
    final base = ThemeData(colorScheme: colorScheme, fontFamily: 'WorkSans', useMaterial3: false);

    return base.copyWith(
      primaryColor: seedColor,
      splashFactory: InkRipple.splashFactory,
      scaffoldBackgroundColor: const Color(0xFFF6F6F6),
      textTheme: _buildTextTheme(base.textTheme),
      primaryTextTheme: _buildTextTheme(base.primaryTextTheme),
      tabBarTheme: const TabBarThemeData(indicatorColor: Colors.white),
      textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: actionColor)),
    );
  }
}
