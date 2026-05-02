import 'package:atelier/theme/atelier_spacing.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:flutter/material.dart';

/// Circular settings gear button (⚙) with hairline rule border.
///
/// Prototype: width/height 26, borderRadius 999, border 1px rule, color sub.
class SettingsGearButton extends StatelessWidget {
  const SettingsGearButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = AtelierTheme.paletteOf(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AtelierSpacing.x3l + AtelierSpacing.sm, // 26
        height: AtelierSpacing.x3l + AtelierSpacing.sm, // 26
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: c.rule),
          borderRadius: BorderRadius.circular(AtelierRadii.pill),
        ),
        child: Center(
          child: Text(
            '⚙',
            style: TextStyle(fontSize: 13, color: c.sub, height: 1),
          ),
        ),
      ),
    );
  }
}
