import 'package:atelier/domain/models/goal.dart';
import 'package:atelier/presentation/features/settings/state/settings_cubit.dart';
import 'package:atelier/theme/atelier_spacing.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:atelier/theme/atelier_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Shows up to N goals inside a pocket card, where N is driven by
/// `SettingsCubit.pocketGoalsPreviewCount` (3 / 5 / all). Starred goals sort
/// first. Starred rows use starBg/starBorder/starInk; normal rows use
/// chip/rule/ink. When the cap is exceeded, shows "+N more" overflow.
///
/// Prototype: gap 5, borderRadius 8, padding 7px 10px, serifBody 12.5.
class PocketGoalsPreview extends StatelessWidget {
  const PocketGoalsPreview({
    super.key,
    required this.goals,
    this.limitOverride,
  });

  final List<Goal> goals;

  /// Resolver that bypasses SettingsCubit when provided. Used by the
  /// settings sheet's live preview. Returning null means "All".
  final ValueGetter<int?>? limitOverride;

  @override
  Widget build(BuildContext context) {
    final c = AtelierTheme.paletteOf(context);
    final limit = limitOverride != null
        ? limitOverride!()
        : context.select<SettingsCubit, int?>(
            (cubit) => cubit.state.settings.pocketGoalsPreviewCount,
          );
    // Starred first, then insertion order (spec §3.3)
    final sorted = [
      ...goals.where((g) => g.starred),
      ...goals.where((g) => !g.starred),
    ];
    final visible = limit == null ? sorted : sorted.take(limit).toList();
    final overflowCount = limit != null && sorted.length > limit
        ? sorted.length - limit
        : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...visible.map((g) {
          final bg = g.starred ? c.starBg : c.chip;
          final border = g.starred ? c.starBorder : c.rule;
          final ink = g.starred ? c.starInk : c.ink;
          return Padding(
            padding: const EdgeInsets.only(bottom: AtelierSpacing.md - 1), // 5
            child: Container(
              decoration: BoxDecoration(
                color: bg,
                border: Border.all(color: border),
                borderRadius: BorderRadius.circular(AtelierRadii.md),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 7,
                horizontal: AtelierSpacing.lg,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (g.starred)
                    Padding(
                      padding: const EdgeInsets.only(
                        right: AtelierSpacing.md,
                        top: AtelierSpacing.sm,
                      ),
                      child: Text(
                        '★',
                        style: TextStyle(color: ink, fontSize: 9, height: 1),
                      ),
                    ),
                  Expanded(
                    child: Text(
                      g.title,
                      style: AtelierTypography.serifBodyUpright.copyWith(
                        color: ink,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        if (overflowCount > 0)
          Padding(
            padding: const EdgeInsets.only(
              left: AtelierSpacing.sm,
              top: AtelierSpacing.xs,
            ),
            child: Text(
              '+$overflowCount more',
              style: AtelierTypography.monoMicro.copyWith(
                color: c.mute,
                fontSize: 9,
                letterSpacing: 1,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
      ],
    );
  }
}
