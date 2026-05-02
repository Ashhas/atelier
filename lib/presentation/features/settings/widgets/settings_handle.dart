import 'package:atelier/theme/atelier_spacing.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:flutter/material.dart';

/// The small pill-shaped drag handle at the top of the settings sheet.
///
/// Prototype: width 38, height 4, background rule colour, borderRadius 999,
/// centred horizontally.
class SettingsHandle extends StatelessWidget {
  const SettingsHandle({super.key});

  @override
  Widget build(BuildContext context) {
    final c = AtelierTheme.paletteOf(context);
    return Center(
      child: Container(
        width: AtelierSpacing.x4l + AtelierSpacing.lg, // 38
        height: AtelierSpacing.sm, // 4
        decoration: BoxDecoration(
          color: c.rule,
          borderRadius: BorderRadius.circular(AtelierRadii.pill),
        ),
      ),
    );
  }
}
