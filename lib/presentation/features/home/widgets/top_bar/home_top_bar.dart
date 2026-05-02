import 'package:atelier/presentation/features/home/widgets/top_bar/days_left_label.dart';
import 'package:atelier/presentation/features/home/widgets/top_bar/done_pill_button.dart';
import 'package:atelier/presentation/features/home/widgets/top_bar/settings_gear_button.dart';
import 'package:atelier/presentation/features/home/widgets/tick_strip/tick_strip.dart';
import 'package:atelier/theme/atelier_spacing.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:atelier/theme/atelier_typography.dart';
import 'package:atelier/utils/date_utils.dart';
import 'package:flutter/material.dart';

/// Top chrome bar for the home screen.
///
/// Renders the italic month display name, year label, days-left, and
/// a settings gear (normal mode) or a Done pill (manage mode).
/// Also houses the TickStrip below the title row.
///
/// Prototype layout: padding 14 22 16, gap between title row and tick 14.
class HomeTopBar extends StatelessWidget {
  const HomeTopBar({
    super.key,
    required this.now,
    required this.isManaging,
    required this.onSettings,
    required this.onDone,
  });

  final DateTime now;
  final bool isManaging;
  final VoidCallback onSettings;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final c = AtelierTheme.paletteOf(context);
    final monthName = AtelierDateUtils.monthName(now.month);
    final year = now.year.toString();

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AtelierSpacing.x3l, // 22
        AtelierSpacing.xl, // 14
        AtelierSpacing.x3l, // 22
        AtelierSpacing.x2l, // 16
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Title row: month + year  |  days-left + gear/done
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              // Month name (italic Fraunces 24)
              Text(
                monthName,
                style: AtelierTypography.serifDisplay.copyWith(color: c.ink),
              ),
              const SizedBox(width: AtelierSpacing.lg), // gap: 10
              // Year label (JetBrains Mono 10 mute)
              Text(
                year,
                style: AtelierTypography.monoLabel.copyWith(
                  color: c.mute,
                  fontSize: 10,
                ),
              ),
              const Spacer(),
              // Right side: days-left + gear  OR  Done pill
              if (isManaging)
                DonePillButton(onTap: onDone)
              else ...[
                DaysLeftLabel(now: now),
                const SizedBox(width: AtelierSpacing.xl), // gap: ~12
                SettingsGearButton(onTap: onSettings),
              ],
            ],
          ),
          const SizedBox(height: AtelierSpacing.xl), // marginBottom: 14
          // Tick strip
          TickStrip(now: now),
        ],
      ),
    );
  }
}
