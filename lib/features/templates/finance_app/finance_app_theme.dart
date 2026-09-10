import 'package:flutter/material.dart';

abstract final class FinanceAppTheme {
  static const background = Color(0xFFF6F4EE);
  static const surface = Color(0xFFFFFEFA);
  static const ink = Color(0xFF182033);
  static const mutedInk = Color(0xFF687084);
  static const primary = Color(0xFF5364F4);
  static const primaryDark = Color(0xFF27368F);
  static const mint = Color(0xFF63D7B0);
  static const coral = Color(0xFFFF8D7A);
  static const amber = Color(0xFFFFC766);
  static const lavender = Color(0xFFE7E9FF);
  static const divider = Color(0xFFE9E6DE);
  static const fontName = 'WorkSans';

  static ThemeData build() {
    const colors = ColorScheme.light(
      primary: primary,
      onPrimary: Colors.white,
      secondary: mint,
      onSecondary: ink,
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

  static const softShadow = <BoxShadow>[BoxShadow(color: Color(0x14182033), blurRadius: 24, offset: Offset(0, 10))];
}
