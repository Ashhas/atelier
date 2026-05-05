import 'package:atelier/domain/models/year_goal.dart';
import 'package:atelier/theme/atelier_spacing.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:atelier/theme/atelier_typography.dart';
import 'package:atelier/theme/content_font_context.dart';
import 'package:flutter/material.dart';

/// Shows the year-goal preview inside a pocket card.
///
/// Prototype: dashed border-bottom 1px rule, padding 0 4px 6px,
/// year label fontSize 8 mono uppercase letterSpacing 1.6,
/// year-goal titles Fraunces italic 12 color sub, ellipsis on overflow.
/// Shows up to 2 expanded year-goal titles; if none shows "no `YYYY` goal".
/// The displayed year reads from [now] (defaults to the system clock).
class PocketYearPreview extends StatelessWidget {
  const PocketYearPreview({
    super.key,
    required this.yearGoalCount,
    required this.expandedYearGoals,
    required this.collapsedCount,
    this.now,
  });

  final int yearGoalCount;
  final List<YearGoal> expandedYearGoals;
  final int collapsedCount;
  final DateTime? now;

  @override
  Widget build(BuildContext context) {
    final c = AtelierTheme.paletteOf(context);
    final font = context.contentFont;
    final year = (now ?? DateTime.now()).year;
    final visible = expandedYearGoals.take(2).toList();
    final overflowCount = expandedYearGoals.length > 2
        ? expandedYearGoals.length - 2
        : 0;

    return Container(
      padding: const EdgeInsets.fromLTRB(
        AtelierSpacing.sm, // 4
        0,
        AtelierSpacing.sm, // 4
        AtelierSpacing.md, // 6
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: c.rule, width: 1, style: BorderStyle.solid),
        ),
      ),
      margin: const EdgeInsets.only(bottom: AtelierSpacing.xs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Year label row
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '$year',
                style: AtelierTypography.monoMicro.copyWith(
                  color: c.mute,
                  fontSize: 8,
                  letterSpacing: 1.6,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              if (yearGoalCount > 1)
                Text(
                  '×$yearGoalCount',
                  style: AtelierTypography.monoMicro.copyWith(
                    color: c.mute,
                    fontSize: 8,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w400,
                  ),
                ),
            ],
          ),
          if (yearGoalCount == 0)
            Padding(
              padding: const EdgeInsets.only(top: AtelierSpacing.sm),
              child: Text(
                'NO $year GOAL',
                style: AtelierTypography.monoMicro.copyWith(
                  color: c.mute,
                  letterSpacing: 1.4,
                ),
              ),
            )
          else ...[
            ...visible.map(
              (yg) => Text(
                '> ${yg.title}',
                style: AtelierTypography.serifBodyUpright(
                  font,
                ).copyWith(color: c.sub, fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (expandedYearGoals.isEmpty && collapsedCount > 0)
              Padding(
                padding: const EdgeInsets.only(top: AtelierSpacing.xs),
                child: Text(
                  '$collapsedCount COLLAPSED',
                  style: AtelierTypography.monoMicro.copyWith(
                    color: c.mute,
                    letterSpacing: 1.4,
                  ),
                ),
              ),
            if (overflowCount > 0)
              Padding(
                padding: const EdgeInsets.only(top: AtelierSpacing.xs),
                child: Text(
                  '+$overflowCount more',
                  style: AtelierTypography.monoMicro.copyWith(
                    color: c.mute,
                    fontSize: 8,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
