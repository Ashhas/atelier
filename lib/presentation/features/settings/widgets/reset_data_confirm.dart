import 'package:atelier/theme/atelier_spacing.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:atelier/theme/atelier_typography.dart';
import 'package:flutter/material.dart';

/// Confirmation panel shown after tapping [ResetDataButton].
///
/// Presents a destructive "RESET" pill and a "CANCEL" pill.
/// Confirm → calls [onReset]. Cancel → calls [onCancel].
///
/// Prototype: border 1px rule, borderRadius 14, surface background; Cancel +
/// Reset buttons side by side as pill buttons.
class ResetDataConfirm extends StatelessWidget {
  const ResetDataConfirm({
    super.key,
    required this.onReset,
    required this.onCancel,
  });

  final VoidCallback onReset;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final c = AtelierTheme.paletteOf(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final resetBg = isDark ? const Color(0xFFc54545) : const Color(0xFFb91c1c);

    return Container(
      padding: const EdgeInsets.all(AtelierSpacing.xl), // 14
      decoration: BoxDecoration(
        color: c.surface,
        border: Border.all(color: c.rule),
        borderRadius: BorderRadius.circular(AtelierRadii.x2l), // 14
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reset everything?',
            style: AtelierTypography.sansLabel.copyWith(color: c.ink),
          ),
          const SizedBox(height: AtelierSpacing.xs),
          Text(
            'All goals, pockets, and progress will be cleared.',
            style: AtelierTypography.sansBody.copyWith(color: c.sub),
          ),
          const SizedBox(height: AtelierSpacing.base + AtelierSpacing.sm), // 12
          Row(
            children: [
              Expanded(
                child: _PillButton(
                  label: 'CANCEL',
                  background: Colors.transparent,
                  textColor: c.ink,
                  border: Border.all(color: c.rule),
                  onTap: onCancel,
                ),
              ),
              const SizedBox(width: AtelierSpacing.base),
              Expanded(
                child: _PillButton(
                  label: 'RESET',
                  background: resetBg,
                  textColor: Colors.white,
                  border: null,
                  onTap: onReset,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  const _PillButton({
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
