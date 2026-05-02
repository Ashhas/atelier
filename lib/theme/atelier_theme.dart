import 'package:atelier/theme/atelier_colors.dart';
import 'package:atelier/theme/atelier_palette.dart';
import 'package:flutter/material.dart';

class AtelierTheme {
  const AtelierTheme._();

  static ThemeData light() => _build(AtelierColors.light, Brightness.light);
  static ThemeData dark() => _build(AtelierColors.dark, Brightness.dark);

  /// Returns the [AtelierPalette] matching the current theme brightness.
  static AtelierPalette paletteOf(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark
        ? AtelierColors.dark
        : AtelierColors.light;
  }

  static ThemeData _build(AtelierPalette p, Brightness brightness) {
    return ThemeData(
      brightness: brightness,
      scaffoldBackgroundColor: p.bg,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: p.ink,
        onPrimary: p.bg,
        secondary: p.accent,
        onSecondary: p.bg,
        error: p.error,
        onError: p.bg,
        surface: p.surface,
        onSurface: p.ink,
      ),
      useMaterial3: false, // we paint everything ourselves
    );
  }
}
