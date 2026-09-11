import 'package:flutter/material.dart';

ThemeData buildTemplateTheme({
  required ColorScheme colors,
  required Color background,
  required Color navigationIndicator,
  required String fontFamily,
  required String displayFontFamily,
}) {
  final theme = ThemeData(
    colorScheme: colors,
    fontFamily: fontFamily,
    scaffoldBackgroundColor: background,
    useMaterial3: true,
  );
  final textTheme = theme.textTheme;

  return theme.copyWith(
    textTheme: textTheme.copyWith(
      displayLarge: textTheme.displayLarge?.copyWith(fontFamily: displayFontFamily),
      displayMedium: textTheme.displayMedium?.copyWith(fontFamily: displayFontFamily),
      displaySmall: textTheme.displaySmall?.copyWith(fontFamily: displayFontFamily),
      headlineLarge: textTheme.headlineLarge?.copyWith(fontFamily: displayFontFamily),
      headlineMedium: textTheme.headlineMedium?.copyWith(fontFamily: displayFontFamily),
      headlineSmall: textTheme.headlineSmall?.copyWith(fontFamily: displayFontFamily),
      titleLarge: textTheme.titleLarge?.copyWith(fontFamily: displayFontFamily),
    ),
    appBarTheme: AppBarThemeData(
      backgroundColor: background,
      foregroundColor: colors.onSurface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: TextStyle(
        color: colors.onSurface,
        fontFamily: displayFontFamily,
        fontSize: 18,
        fontWeight: FontWeight.w800,
      ),
    ),
    cardTheme: CardThemeData(
      color: colors.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
    ),
    inputDecorationTheme: InputDecorationThemeData(
      filled: true,
      fillColor: colors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      border: const OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.all(Radius.circular(18)),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.transparent,
      elevation: 0,
      indicatorColor: navigationIndicator,
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: colors.onSurface,
      contentTextStyle: TextStyle(color: colors.surface, fontFamily: fontFamily),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
    ),
  );
}
