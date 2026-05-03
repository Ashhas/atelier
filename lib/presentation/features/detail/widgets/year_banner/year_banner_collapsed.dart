import 'package:atelier/domain/models/year_goal.dart';
import 'package:atelier/theme/atelier_spacing.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:atelier/theme/atelier_typography.dart';
import 'package:flutter/material.dart';

class YearBannerCollapsed extends StatelessWidget {
  const YearBannerCollapsed({
    super.key,
    required this.yearGoal,
    required this.onToggle,
  });

  final YearGoal yearGoal;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final p = AtelierTheme.paletteOf(context);
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          vertical: AtelierSpacing.lg,
          horizontal: AtelierSpacing.xl,
        ),
        decoration: BoxDecoration(
          color: p.yearBg,
          border: Border.all(color: p.starBorder),
          borderRadius: BorderRadius.circular(AtelierRadii.lg),
        ),
        child: Row(
          children: [
            Text(
              '${DateTime.now().year}',
              style: AtelierTypography.monoMicro.copyWith(
                color: p.mute,
                letterSpacing: 1.6,
              ),
            ),
            const SizedBox(width: AtelierSpacing.lg),
            Expanded(
              child: Text(
                yearGoal.title,
                style: AtelierTypography.serifTitleUpright.copyWith(
                  color: p.ink,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
