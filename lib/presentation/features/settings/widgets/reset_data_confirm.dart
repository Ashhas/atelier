import 'package:atelier/presentation/features/settings/widgets/reset_pill_button.dart';
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
                child: ResetPillButton(
                  label: 'CANCEL',
                  background: Colors.transparent,
                  textColor: c.ink,
                  border: Border.all(color: c.rule),
                  onTap: onCancel,
                ),
              ),
              const SizedBox(width: AtelierSpacing.base),
              Expanded(
                child: ResetPillButton(
                  label: 'RESET',
                  background: c.error,
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
