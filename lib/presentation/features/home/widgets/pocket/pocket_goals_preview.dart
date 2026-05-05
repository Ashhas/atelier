import 'package:atelier/domain/models/goal.dart';
import 'package:atelier/theme/atelier_spacing.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:atelier/theme/atelier_typography.dart';
import 'package:atelier/theme/content_font_context.dart';
import 'package:flutter/material.dart';

/// Shows up to 3 goals inside a pocket card; starred goals sort first.
/// Starred rows use starBg/starBorder/starInk; normal rows use chip/rule/ink.
/// If more than 3 goals exist, shows "+N more" overflow.
///
/// Prototype: gap 5, borderRadius 8, padding 7px 10px, serifBody 12.5.
class PocketGoalsPreview extends StatelessWidget {
  const PocketGoalsPreview({super.key, required this.goals});

  final List<Goal> goals;

  @override
  Widget build(BuildContext context) {
    final c = AtelierTheme.paletteOf(context);
    final font = context.contentFont;
    // Starred first, then insertion order (spec §3.3)
    final sorted = [
      ...goals.where((g) => g.starred),
      ...goals.where((g) => !g.starred),
    ];
    final visible = sorted.take(3).toList();
    final overflowCount = sorted.length > 3 ? sorted.length - 3 : 0;

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
                      style: AtelierTypography.serifBodyUpright(
                        font,
                      ).copyWith(color: ink),
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
