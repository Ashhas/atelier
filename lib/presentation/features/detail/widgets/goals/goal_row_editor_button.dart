import 'package:atelier/theme/atelier_spacing.dart';
import 'package:atelier/theme/atelier_typography.dart';
import 'package:flutter/material.dart';

/// Save / Cancel button used inside [GoalRowEditor].
class GoalRowEditorButton extends StatelessWidget {
  const GoalRowEditorButton({
    super.key,
    required this.label,
    required this.onTap,
    required this.background,
    required this.foreground,
    required this.borderColor,
  });

  final String label;
  final VoidCallback onTap;
  final Color background;
  final Color foreground;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AtelierSpacing.md,
          horizontal: AtelierSpacing.base + AtelierSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: background,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(AtelierRadii.sm),
        ),
        child: Text(
          label,
          style: AtelierTypography.monoLabel.copyWith(
            color: foreground,
            fontSize: 9.5,
            letterSpacing: 1.4,
          ),
        ),
      ),
    );
  }
}
