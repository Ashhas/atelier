import 'package:atelier/domain/models/year_goal.dart';
import 'package:atelier/domain/models/enums/pocket_year_line_mode.dart';
import 'package:atelier/presentation/features/settings/state/settings_cubit.dart';
import 'package:atelier/theme/atelier_spacing.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:atelier/theme/atelier_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Shows the year-goal preview inside a pocket card.
///
/// Prototype: dashed border-bottom 1px rule, padding 0 4px 6px,
/// "NORTH STAR" eyebrow fontSize 8 mono uppercase letterSpacing 1.6,
/// year-goal titles Fraunces italic 12 color sub. Title line count is
/// driven by `SettingsCubit.pocketYearLineMode` (1 / 2 / full).
/// Shows up to 2 expanded year-goal titles; if none, shows "NO NORTH STAR".
class PocketYearPreview extends StatelessWidget {
  const PocketYearPreview({
    super.key,
    required this.yearGoalCount,
    required this.expandedYearGoals,
    required this.collapsedCount,
  });

  final int yearGoalCount;
  final List<YearGoal> expandedYearGoals;
  final int collapsedCount;

  @override
  Widget build(BuildContext context) {
    final c = AtelierTheme.paletteOf(context);
    final lineMode = context
        .select<SettingsCubit, PocketYearLineMode>(
          (cubit) => cubit.state.settings.pocketYearLineMode,
        );
    final maxLines = lineMode.maxLines;
    final visible = expandedYearGoals.take(2).toList();
    final overflowCount = expandedYearGoals.length > 2
        ? expandedYearGoals.length - 2
        : 0;

    return Container(
      padding: const EdgeInsets.fromLTRB(
        AtelierSpacing.sm, // 4
        AtelierSpacing.md, // 6
        AtelierSpacing.sm, // 4
        AtelierSpacing.lg, // 10
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: c.rule, width: 1, style: BorderStyle.solid),
        ),
      ),
      margin: const EdgeInsets.only(bottom: AtelierSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Year label row
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                yearGoalCount == 0 ? 'NO NORTH STAR' : 'NORTH STAR',
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
          if (yearGoalCount > 0) ...[
            // Breathing room between the small-caps eyebrow and the
            // year-goal titles below — without it the label and the first
            // goal title visually hug.
            const SizedBox(height: AtelierSpacing.sm),
            ...visible.map((yg) {
              final titleStyle = AtelierTypography.serifBodyUpright.copyWith(
                color: c.sub,
                fontSize: 12,
              );
              // Bullet sits in its own column so wrapped lines hang to the
              // title's indent instead of tucking under the '•'.
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 14,
                    child: Text('•', style: titleStyle),
                  ),
                  Expanded(
                    child: Text(
                      yg.title,
                      style: titleStyle,
                      maxLines: maxLines,
                      overflow: maxLines == null
                          ? TextOverflow.clip
                          : TextOverflow.ellipsis,
                    ),
                  ),
                ],
              );
            }),
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
