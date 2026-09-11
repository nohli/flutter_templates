import 'package:flutter/material.dart';

import '../shared/template_theme.dart';

abstract final class FoodDeliveryAppTheme {
  static const background = Color(0xFFFFF8EE);
  static const surface = Color(0xFFFFFFFF);
  static const ink = Color(0xFF25352D);
  static const mutedInk = Color(0xFF69746E);
  static const primary = Color(0xFFC94B31);
  static const deepOrange = Color(0xFFA83A24);
  static const green = Color(0xFF326B52);
  static const mint = Color(0xFFDDEBDB);
  static const peach = Color(0xFFFFD9C8);
  static const yellow = Color(0xFFFFE7A3);
  static const divider = Color(0xFFEDE5D9);
  static const fontName = 'BricolageGrotesque';
  static const displayFontName = 'BricolageGrotesque';

  static ThemeData build([Brightness brightness = Brightness.light]) {
    final isDark = brightness == Brightness.dark;
    final colors = isDark
        ? const ColorScheme.dark(
            primary: Color(0xFFFFAA8F),
            onPrimary: Color(0xFF5E1305),
            primaryContainer: Color(0xFF3D2018),
            onPrimaryContainer: Color(0xFFFFDAD0),
            secondary: Color(0xFF9FD6B6),
            onSecondary: Color(0xFF073824),
            secondaryContainer: Color(0xFF29483A),
            onSecondaryContainer: Color(0xFFBCEED0),
            surface: Color(0xFF221E1A),
            onSurface: Color(0xFFF7F0E8),
            error: Color(0xFFFFB4AB),
            onError: Color(0xFF690005),
            outline: Color(0xFFA59B91),
            outlineVariant: Color(0xFF4E463F),
          )
        : const ColorScheme.light(
            primary: primary,
            onPrimary: Colors.white,
            primaryContainer: ink,
            onPrimaryContainer: Colors.white,
            secondary: green,
            onSecondary: Colors.white,
            secondaryContainer: mint,
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
      background: isDark ? const Color(0xFF15120F) : background,
      navigationIndicator: isDark ? const Color(0xFF593126) : peach,
      fontFamily: fontName,
      displayFontFamily: displayFontName,
    );
  }

  static const softShadow = <BoxShadow>[BoxShadow(color: Color(0x1425352D), blurRadius: 20, offset: Offset(0, 8))];
}
