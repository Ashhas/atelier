import 'package:atelier/theme/atelier_spacing.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:atelier/theme/atelier_typography.dart';
import 'package:flutter/material.dart';

/// Primary "Reset all data" trigger button.
///
/// Tapping it calls [onTap] — callers swap this for [ResetDataConfirm] as a
/// two-step guard. The button itself is stateless; state lives in the parent.
///
/// Prototype: border 1px rule, borderRadius 14, flex-column with title +
/// subtitle.
class ResetDataButton extends StatelessWidget {
  const ResetDataButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = AtelierTheme.paletteOf(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AtelierSpacing.x2l), // 16
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: c.rule),
          borderRadius: BorderRadius.circular(AtelierRadii.x2l), // 14
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reset all data',
              style: AtelierTypography.sansLabel.copyWith(color: c.ink),
            ),
            const SizedBox(height: AtelierSpacing.xs),
            Text(
              'Removes all goals and pockets. Cannot be undone.',
              style: AtelierTypography.sansBody.copyWith(color: c.sub),
            ),
          ],
        ),
      ),
    );
  }
}
