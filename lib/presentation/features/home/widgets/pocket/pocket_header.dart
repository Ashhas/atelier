import 'package:atelier/theme/atelier_spacing.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:atelier/theme/atelier_typography.dart';
import 'package:flutter/material.dart';

/// Pocket card header row: category name (mono eyebrow) + goal count (mono micro).
///
/// Prototype: justifyContent space-between, padding 0 4px 4px,
/// name letterSpacing 1.8, count letterSpacing 1.
class PocketHeader extends StatelessWidget {
  const PocketHeader({super.key, required this.name, required this.goalCount});

  final String name;
  final int goalCount;

  @override
  Widget build(BuildContext context) {
    final c = AtelierTheme.paletteOf(context);
    final countStr = goalCount == 0
        ? '—'
        : goalCount.toString().padLeft(2, '0');
    return Padding(
      padding: const EdgeInsets.only(
        left: AtelierSpacing.sm,
        right: AtelierSpacing.sm,
        bottom: AtelierSpacing.sm,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(
            name.toUpperCase(),
            // Inter eyebrow — same heft + tracking as the mono variant
            // it replaced, just on the body sans for a calmer feel.
            style: AtelierTypography.sansLabel.copyWith(
              color: c.sub,
              fontSize: 11,
              letterSpacing: 1.8,
            ),
          ),
          const Spacer(),
          Text(
            countStr,
            style: AtelierTypography.monoMicro.copyWith(
              color: c.mute,
              letterSpacing: 1,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
