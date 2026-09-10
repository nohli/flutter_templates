import 'package:flutter/material.dart';

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
  static const fontName = 'WorkSans';

  static ThemeData build() {
    const colors = ColorScheme.light(
      primary: primary,
      onPrimary: Colors.white,
      secondary: green,
      onSecondary: Colors.white,
      surface: surface,
      onSurface: ink,
      error: Color(0xFFBA1A1A),
      onError: Colors.white,
      outline: mutedInk,
      outlineVariant: divider,
    );

    return ThemeData(
      colorScheme: colors,
      fontFamily: fontName,
      scaffoldBackgroundColor: background,
      useMaterial3: true,
    );
  }

  static const softShadow = <BoxShadow>[BoxShadow(color: Color(0x1425352D), blurRadius: 20, offset: Offset(0, 8))];
}
