import 'package:atelier/theme/atelier_spacing.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:atelier/theme/atelier_typography.dart';
import 'package:atelier/utils/date_utils.dart';
import 'package:flutter/material.dart';

class GoalRowDaysLabel extends StatelessWidget {
  const GoalRowDaysLabel({super.key, required this.addedAt});

  final DateTime addedAt;

  @override
  Widget build(BuildContext context) {
    final p = AtelierTheme.paletteOf(context);
    final days = AtelierDateUtils.daysSince(addedAt, DateTime.now());
    final label = AtelierDateUtils.formatDaysSince(days);
    return Padding(
      padding: const EdgeInsets.only(top: AtelierSpacing.base),
      child: Text(
        label,
        style: AtelierTypography.monoMicro.copyWith(
          color: p.mute,
          letterSpacing: 1,
        ),
      ),
    );
  }
}
