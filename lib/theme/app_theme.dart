import 'package:flutter/material.dart';

/// NOCTIS XXIV design tokens.
/// Centralised here so every widget pulls colors/spacing from one place —
/// change the palette once, it updates everywhere.
class AppColors {
  static const bg = Color(0xFFF4F4F4);
  static const panel = Color(0xFFFFFFFF);
  static const panelTint = Color(0xFFFDF3F3);
  static const border = Color(0xFFECECEC);

  static const red = Color(0xFFD81E1E);
  static const redDark = Color(0xFFB31414);
  static const black = Color(0xFF16161A);
  static const gray = Color(0xFF6B6B70);
  static const grayLight = Color(0xFF9A9AA0);

  static const bullish = Color(0xFF1A8C3F);
  static const bearish = Color(0xFFE0392F);
  static const asian = Color(0xFF1A5FB4);
  static const afterHours = Color(0xFFC8781D);
}

class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 20.0;
  static const xl = 24.0;
}

class AppRadius {
  static const card = 12.0;
  static const button = 8.0;
  static const app = 16.0;
}

final ThemeData noctisTheme = ThemeData(
  scaffoldBackgroundColor: AppColors.bg,
  fontFamily: 'Segoe UI',
  colorScheme: ColorScheme.light(
    primary: AppColors.red,
    surface: AppColors.panel,
  ),
  useMaterial3: true,
);
