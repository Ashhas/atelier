import 'package:atelier/theme/atelier_spacing.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:atelier/theme/atelier_typography.dart';
import 'package:atelier/utils/date_utils.dart';
import 'package:flutter/material.dart';

/// Renders "X DAYS LEFT" with X in ink and "DAYS LEFT" in mute.
///
/// Dimensions come from the prototype: fontSize 10, letterSpacing 1.4.
class DaysLeftLabel extends StatelessWidget {
  const DaysLeftLabel({super.key, required this.now});

  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final c = AtelierTheme.paletteOf(context);
    final daysInMonth = AtelierDateUtils.daysInMonth(now.year, now.month);
    final daysLeft = daysInMonth - now.day;
    final style = AtelierTypography.monoLabel;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$daysLeft',
          style: style.copyWith(color: c.ink, fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: AtelierSpacing.xs),
        Text('DAYS LEFT', style: style.copyWith(color: c.mute)),
      ],
    );
  }
}
