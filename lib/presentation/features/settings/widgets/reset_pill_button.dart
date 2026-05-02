import 'package:atelier/theme/atelier_spacing.dart';
import 'package:atelier/theme/atelier_typography.dart';
import 'package:flutter/material.dart';

/// Pill-shaped button used by the reset-confirmation panel for both
/// CANCEL (transparent + outlined) and RESET (red filled) actions.
class ResetPillButton extends StatelessWidget {
  const ResetPillButton({
    super.key,
    required this.label,
    required this.background,
    required this.textColor,
    required this.border,
    required this.onTap,
  });

  final String label;
  final Color background;
  final Color textColor;
  final BoxBorder? border;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AtelierSpacing.lg,
          horizontal: AtelierSpacing.base + AtelierSpacing.sm, // 12
        ),
        decoration: BoxDecoration(
          color: background,
          border: border,
          borderRadius: BorderRadius.circular(AtelierRadii.pill),
        ),
        child: Center(
          child: Text(
            label,
            style: AtelierTypography.monoLabel.copyWith(color: textColor),
          ),
        ),
      ),
    );
  }
}
