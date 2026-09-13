import 'package:flutter/material.dart';

abstract final class HotelAppTheme {
  static const seedColor = Color(0xFF54D3C2);
  static const actionColor = Color(0xFF006A60);
  static const rangeColor = Color(0xFFBBEDE7);
  static const darkBackground = Color(0xFF0B1418);
  static const darkSurface = Color(0xFF132126);

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

  static ThemeData build([Brightness brightness = Brightness.light]) {
    final dark = brightness == Brightness.dark;
    final colorScheme = dark
        ? const ColorScheme.dark(
            primary: Color(0xFF67E0D1),
            onPrimary: Color(0xFF06201D),
            primaryContainer: Color(0xFF16443F),
            onPrimaryContainer: Color(0xFFB9FFF5),
            secondary: Color(0xFF8DE9DD),
            onSecondary: Color(0xFF08201D),
            surface: darkSurface,
            onSurface: Color(0xFFF0F7F6),
            onSurfaceVariant: Color(0xFFB5C8CA),
            outline: Color(0xFF92AAAD),
            outlineVariant: Color(0xFF304449),
            error: Color(0xFFFFB4AB),
            onError: Color(0xFF690005),
          )
        : const ColorScheme.light(
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
      primaryColor: colorScheme.primary,
      splashFactory: InkRipple.splashFactory,
      scaffoldBackgroundColor: dark ? darkBackground : const Color(0xFFF6F6F6),
      textTheme: _buildTextTheme(base.textTheme),
      primaryTextTheme: _buildTextTheme(base.primaryTextTheme),
      tabBarTheme: TabBarThemeData(indicatorColor: colorScheme.onPrimary),
      textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: colorScheme.secondary)),
    );
  }
}
