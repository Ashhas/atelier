import 'package:atelier/theme/atelier_palette.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:atelier/theme/atelier_typography.dart';
import 'package:atelier/utils/date_utils.dart';
import 'package:flutter/material.dart';

class TickStripTodayLabel extends StatelessWidget {
  const TickStripTodayLabel({
    super.key,
    required this.day,
    required this.totalDays,
    required this.stripWidth,
  });

  final int day;
  final int totalDays;
  final double stripWidth;

  int get _percent => ((day / totalDays) * 100).round();

  @override
  Widget build(BuildContext context) {
    final AtelierPalette p = AtelierTheme.paletteOf(context);
    final leftPct = (day - 1) / (totalDays - 1);

    return Positioned(
      left: leftPct * stripWidth - 30,
      top: -2,
      child: Text.rich(
        TextSpan(
          style: AtelierTypography.monoMicro,
          children: [
            TextSpan(
              text: 'D$day${AtelierDateUtils.ordinalSuffix(day)}',
              style: TextStyle(color: p.ink, fontWeight: FontWeight.w600),
            ),
            TextSpan(
              text: ' · $_percent%',
              style: TextStyle(color: p.mute, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
