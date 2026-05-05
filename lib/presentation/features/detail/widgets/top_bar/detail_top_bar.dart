import 'package:atelier/presentation/features/detail/widgets/top_bar/detail_back_button.dart';
import 'package:atelier/presentation/features/detail/widgets/top_bar/detail_count_label.dart';
import 'package:atelier/theme/atelier_spacing.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:atelier/theme/atelier_typography.dart';
import 'package:flutter/material.dart';

class DetailTopBar extends StatelessWidget {
  const DetailTopBar({
    super.key,
    required this.name,
    required this.monthCount,
    required this.yearCount,
    required this.onBack,
  });

  final String name;
  final int monthCount;
  final int yearCount;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final p = AtelierTheme.paletteOf(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AtelierSpacing.xl,
        AtelierSpacing.xl,
        AtelierSpacing.xl,
        AtelierSpacing.lg,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          DetailBackButton(onBack: onBack),
          const SizedBox(width: AtelierSpacing.lg),
          Expanded(
            child: Text(
              name,
              // Pocket name on detail screens: Inter, matching goal-text
              // body. Home keeps Fraunces italic for the month name —
              // detail headers used to too, but the serif felt too
              // thematic for short user-typed pocket names.
              style: AtelierTypography.serifDisplayUpright.copyWith(
                color: p.ink,
              ),
            ),
          ),
          DetailCountLabel(monthCount: monthCount, yearCount: yearCount),
        ],
      ),
    );
  }
}
