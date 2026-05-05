import 'package:atelier/domain/models/year_goal.dart';
import 'package:atelier/theme/atelier_spacing.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:atelier/theme/atelier_typography.dart';
import 'package:atelier/theme/content_font_context.dart';
import 'package:flutter/material.dart';

class YearBannerExpanded extends StatelessWidget {
  const YearBannerExpanded({
    super.key,
    required this.yearGoal,
    required this.onToggle,
    required this.onDelete,
  });

  final YearGoal yearGoal;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final p = AtelierTheme.paletteOf(context);
    final font = context.contentFont;
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(
          AtelierSpacing.x2l,
          AtelierSpacing.xl,
          AtelierSpacing.x2l,
          AtelierSpacing.x2l,
        ),
        decoration: BoxDecoration(
          color: p.yearBg,
          border: Border.all(color: p.starBorder),
          borderRadius: BorderRadius.circular(AtelierRadii.x2l),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${DateTime.now().year} · NORTH STAR',
                    style: AtelierTypography.monoEyebrow.copyWith(color: p.sub),
                  ),
                ),
                GestureDetector(
                  onTap: onDelete,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: p.chip,
                      border: Border.all(color: p.rule),
                      borderRadius: BorderRadius.circular(AtelierRadii.pill),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '×',
                      style: AtelierTypography.monoLabel.copyWith(
                        color: p.ink,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AtelierSpacing.base),
            Text(
              yearGoal.title,
              style: AtelierTypography.serifDisplayUpright(font).copyWith(
                color: p.ink,
                fontSize: 20,
                letterSpacing: -0.4,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
