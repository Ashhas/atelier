import 'package:atelier/theme/atelier_spacing.dart';
import 'package:atelier/theme/atelier_typography.dart';
import 'package:flutter/material.dart';

/// A small mono-label button used in [GoalRowActions] for Edit / Remove.
class GoalRowActionButton extends StatelessWidget {
  const GoalRowActionButton({
    super.key,
    required this.label,
    required this.onTap,
    required this.color,
    required this.borderColor,
    required this.background,
  });

  final String label;
  final VoidCallback onTap;
  final Color color;
  final Color borderColor;
  final Color background;

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
            color: color,
            fontSize: 9.5,
            letterSpacing: 1.4,
          ),
        ),
      ),
    );
  }
}
