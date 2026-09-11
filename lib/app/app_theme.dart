import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const notWhite = Color(0xFFEDF0F2);
  static const nearlyWhite = Color(0xFFFEFEFE);
  static const white = Color(0xFFFFFFFF);
  static const nearlyBlack = Color(0xFF213333);
  static const grey = Color(0xFF3A5160);
  static const darkGrey = Color(0xFF313A44);
  static const darkText = Color(0xFF253840);
  static const darkerText = Color(0xFF17262A);
  static const lightText = Color(0xFF4A6572);
  static const actionBlue = Color(0xFF0D47A1);
  static const fontName = 'WorkSans';

  static ThemeData build([Brightness brightness = Brightness.light]) {
    final colors = brightness == Brightness.dark
        ? const ColorScheme.dark(
            primary: Color(0xFF7DC4FF),
            onPrimary: Color(0xFF002F4D),
            primaryContainer: Color(0xFF12496C),
            onPrimaryContainer: Color(0xFFD0E9FF),
            surface: Color(0xFF111719),
            onSurface: Color(0xFFE4F0F2),
            error: Color(0xFFFFB4AB),
            onError: Color(0xFF690005),
          )
        : const ColorScheme.light(
            primary: Colors.blue,
            onPrimary: darkerText,
            primaryContainer: Color(0xFFD5ECFF),
            onPrimaryContainer: darkerText,
            surface: nearlyWhite,
            onSurface: darkerText,
            error: Color(0xFFB00020),
            onError: white,
          );
    final base = ThemeData(colorScheme: colors, fontFamily: fontName, useMaterial3: false);

    return base.copyWith(
      scaffoldBackgroundColor: colors.surface,
      textTheme: base.textTheme.merge(textTheme).apply(bodyColor: colors.onSurface, displayColor: colors.onSurface),
    );
  }

  static const textTheme = TextTheme(
    headlineMedium: display1,
    headlineSmall: headline,
    titleLarge: title,
    titleSmall: subtitle,
    bodyMedium: body2,
    bodyLarge: body1,
    bodySmall: caption,
  );

  static const display1 = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 36,
    letterSpacing: 0.4,
    height: 0.9,
    color: darkerText,
  );

  static const headline = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 24,
    letterSpacing: 0.27,
    color: darkerText,
  );

  static const title = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 16,
    letterSpacing: 0.18,
    color: darkerText,
  );

  static const subtitle = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: -0.04,
    color: darkText,
  );

  static const body2 = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: 0.2,
    color: darkText,
  );

  static const body1 = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    letterSpacing: -0.05,
    color: darkText,
  );

  static const caption = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    letterSpacing: 0.2,
    color: lightText,
  );
}
