import 'package:flutter/material.dart';

class FitnessAppTheme {
  FitnessAppTheme._();

  static const Color nearlyWhite = Color(0xFFFAFAFA);
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF2F3F8);
  static const Color nearlyDarkBlue = Color(0xFF2633C5);
  static const Color nearlyBlue = Color(0xFF00B6F0);
  static const Color nearlyBlack = Color(0xFF213333);
  static const Color grey = Color(0xFF3A5160);
  static const Color darkText = Color(0xFF253840);
  static const Color darkerText = Color(0xFF17262A);
  static const Color lightText = Color(0xFF4A6572);
  static const Color spacer = Color(0xFFF2F2F2);
  static const Color seedColor = nearlyDarkBlue;
  static const fontName = 'Roboto';

  static ThemeData build() {
    const colors = ColorScheme.light(
      primary: nearlyDarkBlue,
      onPrimary: white,
      primaryContainer: Color(0xFFD7E0F9),
      onPrimaryContainer: nearlyDarkBlue,
      secondary: nearlyBlue,
      onSecondary: nearlyBlack,
      surface: white,
      onSurface: darkerText,
      onSurfaceVariant: lightText,
      outline: grey,
      outlineVariant: spacer,
      error: Color(0xFFB00020),
      onError: white,
    );
    final themedText = textTheme.copyWith(
      headlineMedium: display1.copyWith(color: colors.onSurface),
      headlineSmall: headline.copyWith(color: colors.onSurface),
      titleLarge: title.copyWith(color: colors.onSurface),
      titleSmall: subtitle.copyWith(color: colors.onSurface),
      bodyMedium: body2.copyWith(color: colors.onSurface),
      bodyLarge: body1.copyWith(color: colors.onSurface),
      bodySmall: caption.copyWith(color: colors.onSurfaceVariant),
    );
    final base = ThemeData(colorScheme: colors, fontFamily: fontName, useMaterial3: false);

    return base.copyWith(scaffoldBackgroundColor: background, textTheme: base.textTheme.merge(themedText));
  }

  static const TextTheme textTheme = TextTheme(
    headlineMedium: display1,
    headlineSmall: headline,
    titleLarge: title,
    titleSmall: subtitle,
    bodyMedium: body2,
    bodyLarge: body1,
    bodySmall: caption,
  );

  static const TextStyle display1 = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 36,
    letterSpacing: 0.4,
    height: 0.9,
  );

  static const TextStyle headline = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 24,
    letterSpacing: 0.27,
  );

  static const TextStyle title = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 16,
    letterSpacing: 0.18,
  );

  static const TextStyle subtitle = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: -0.04,
  );

  static const TextStyle body2 = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: 0.2,
  );

  static const TextStyle body1 = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    letterSpacing: -0.05,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    letterSpacing: 0.2,
  );
}
