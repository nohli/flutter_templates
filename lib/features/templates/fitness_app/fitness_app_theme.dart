import 'package:flutter/material.dart';

abstract final class FitnessAppTheme {
  static const nearlyWhite = Color(0xFFFAFAFA);
  static const white = Color(0xFFFFFFFF);
  static const background = Color(0xFFF2F3F8);
  static const nearlyDarkBlue = Color(0xFF2633C5);
  static const nearlyBlue = Color(0xFF00B6F0);
  static const nearlyBlack = Color(0xFF213333);
  static const grey = Color(0xFF3A5160);
  static const darkText = Color(0xFF253840);
  static const darkerText = Color(0xFF17262A);
  static const lightText = Color(0xFF4A6572);
  static const spacer = Color(0xFFF2F2F2);
  static const darkBackground = Color(0xFF0B0E17);
  static const darkSurface = Color(0xFF151A27);
  static const seedColor = nearlyDarkBlue;
  static const fontName = 'Roboto';

  static ThemeData build([Brightness brightness = Brightness.light]) {
    final dark = brightness == Brightness.dark;
    final colors = dark
        ? const ColorScheme.dark(
            primary: Color(0xFFAAB7FF),
            onPrimary: Color(0xFF10194E),
            primaryContainer: Color(0xFF303A78),
            onPrimaryContainer: Color(0xFFE0E4FF),
            secondary: Color(0xFF64D7FF),
            onSecondary: Color(0xFF003544),
            surface: darkSurface,
            onSurface: Color(0xFFF3F5FF),
            surfaceDim: darkBackground,
            surfaceBright: Color(0xFF343A4B),
            surfaceContainerLowest: Color(0xFF080B12),
            surfaceContainerLow: Color(0xFF111622),
            surfaceContainer: Color(0xFF171D2B),
            surfaceContainerHigh: Color(0xFF1F2636),
            surfaceContainerHighest: Color(0xFF283143),
            onSurfaceVariant: Color(0xFFBCC4D8),
            outline: Color(0xFF929BB2),
            outlineVariant: Color(0xFF363E51),
            error: Color(0xFFFFB4AB),
            onError: Color(0xFF690005),
          )
        : const ColorScheme.light(
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

    return base.copyWith(
      primaryColor: colors.primary,
      scaffoldBackgroundColor: dark ? darkBackground : background,
      textTheme: base.textTheme.merge(themedText),
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
  );

  static const headline = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 24,
    letterSpacing: 0.27,
  );

  static const title = TextStyle(fontFamily: fontName, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 0.18);

  static const subtitle = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: -0.04,
  );

  static const body2 = TextStyle(fontFamily: fontName, fontWeight: FontWeight.w400, fontSize: 14, letterSpacing: 0.2);

  static const body1 = TextStyle(fontFamily: fontName, fontWeight: FontWeight.w400, fontSize: 16, letterSpacing: -0.05);

  static const caption = TextStyle(fontFamily: fontName, fontWeight: FontWeight.w400, fontSize: 12, letterSpacing: 0.2);
}
