import 'package:atelier/theme/atelier_palette.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:flutter/material.dart';

class TickStripTickMark extends StatelessWidget {
  const TickStripTickMark({
    super.key,
    required this.day,
    required this.totalDays,
    required this.isToday,
    required this.stripWidth,
  });

  final int day;
  final int totalDays;
  final bool isToday;
  final double stripWidth;

  bool get _isMajor => day == 1 || day == totalDays || day % 5 == 0;

  @override
  Widget build(BuildContext context) {
    final AtelierPalette p = AtelierTheme.paletteOf(context);
    final width = isToday ? 2.0 : 1.0;
    final height = isToday ? 14.0 : (_isMajor ? 6.0 : 3.0);
    final leftPct = (day - 1) / (totalDays - 1);

    return Positioned(
      left: leftPct * stripWidth - width / 2,
      top: 13,
      child: Container(
        width: width,
        height: height,
        color: isToday ? p.accent : p.rule,
      ),
    );
  }
}
