import 'package:flutter/material.dart';

abstract final class DesignCourseAppTheme {
  static const nearlyWhite = Color(0xFFFFFFFF);
  static const nearlyBlue = Color(0xFF00B6F0);
  static const nearlyBlack = Color(0xFF213333);
  static const grey = Color(0xFF3A5160);
  static const darkText = Color(0xFF253840);
  static const darkerText = Color(0xFF17262A);
  static const lightText = Color(0xFF4A6572);
  static const cardBackground = Color(0xFFF8FAFB);
  static const spacer = Color(0xFFF2F2F2);
  static const darkBackground = Color(0xFF0B1218);
  static const darkSurface = Color(0xFF101A21);
  static const fontName = 'WorkSans';

  static ThemeData build([Brightness brightness = Brightness.light]) {
    final dark = brightness == Brightness.dark;
    final colors = dark
        ? const ColorScheme.dark(
            primary: Color(0xFF56D7FF),
            onPrimary: Color(0xFF003544),
            primaryContainer: Color(0xFF004D63),
            onPrimaryContainer: Color(0xFFC3F0FF),
            secondary: Color(0xFF93CCFF),
            onSecondary: Color(0xFF003353),
            surface: darkSurface,
            onSurface: Color(0xFFF1F7FA),
            surfaceDim: darkBackground,
            surfaceBright: Color(0xFF33414A),
            surfaceContainerLowest: Color(0xFF070C10),
            surfaceContainerLow: Color(0xFF16232B),
            surfaceContainer: Color(0xFF1A2831),
            surfaceContainerHigh: Color(0xFF22323C),
            surfaceContainerHighest: Color(0xFF2B3C46),
            onSurfaceVariant: Color(0xFFB8C9D0),
            outline: Color(0xFF91A6AE),
            outlineVariant: Color(0xFF33454E),
            error: Color(0xFFFFB4AB),
            onError: Color(0xFF690005),
          )
        : const ColorScheme.light(
            primary: nearlyBlue,
            onPrimary: nearlyBlack,
            surface: nearlyWhite,
            onSurface: darkerText,
            surfaceContainerLow: cardBackground,
            onSurfaceVariant: lightText,
            outline: grey,
            outlineVariant: spacer,
            error: Color(0xFFB00020),
            onError: nearlyWhite,
          );
    final themedText = textTheme.copyWith(
      headlineMedium: display1.copyWith(color: colors.onSurface),
      headlineSmall: headline.copyWith(color: colors.onSurface),
      titleLarge: title.copyWith(color: colors.onSurface),
      titleSmall: subtitle.copyWith(color: colors.onSurface),
      bodyLarge: body2.copyWith(color: colors.onSurface),
      bodyMedium: body1.copyWith(color: colors.onSurface),
      bodySmall: caption.copyWith(color: colors.onSurfaceVariant),
    );
    final base = ThemeData(colorScheme: colors, fontFamily: fontName, useMaterial3: false);

    return base.copyWith(
      primaryColor: colors.primary,
      scaffoldBackgroundColor: dark ? darkBackground : nearlyWhite,
      textTheme: base.textTheme.merge(themedText),
    );
  }

  static const textTheme = TextTheme(
    headlineMedium: display1,
    headlineSmall: headline,
    titleLarge: title,
    titleSmall: subtitle,
    bodyLarge: body2,
    bodyMedium: body1,
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
