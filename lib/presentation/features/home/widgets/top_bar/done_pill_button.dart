import 'package:atelier/theme/atelier_spacing.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:atelier/theme/atelier_typography.dart';
import 'package:flutter/material.dart';

/// Done pill button shown in manage mode (replaces gear button).
///
/// Prototype: background ink, color bg, borderRadius 999,
/// padding 5px vertical 12px horizontal, fontSize 9.5 mono uppercase.
class DonePillButton extends StatelessWidget {
  const DonePillButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = AtelierTheme.paletteOf(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 5,
          horizontal: AtelierSpacing.xl, // 14 ≈ 12
        ),
        decoration: BoxDecoration(
          color: c.ink,
          borderRadius: BorderRadius.circular(AtelierRadii.pill),
        ),
        child: Text(
          'DONE',
          style: AtelierTypography.monoLabel.copyWith(
            color: c.bg,
            fontSize: 9.5,
          ),
        ),
      ),
    );
  }
}
