import 'package:atelier/presentation/features/home/widgets/tick_strip/tick_strip_baseline.dart';
import 'package:atelier/presentation/features/home/widgets/tick_strip/tick_strip_tick_mark.dart';
import 'package:atelier/presentation/features/home/widgets/tick_strip/tick_strip_today_label.dart';
import 'package:atelier/utils/date_utils.dart';
import 'package:flutter/material.dart';

class TickStrip extends StatelessWidget {
  const TickStrip({super.key, required this.now});

  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final totalDays = AtelierDateUtils.daysInMonth(now.year, now.month);
    final today = now.day;
    return SizedBox(
      height: 22,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final stripWidth = constraints.maxWidth;
          return Stack(
            children: [
              const TickStripBaseline(),
              for (var d = 1; d <= totalDays; d++)
                TickStripTickMark(
                  day: d,
                  totalDays: totalDays,
                  isToday: d == today,
                  stripWidth: stripWidth,
                ),
              TickStripTodayLabel(
                day: today,
                totalDays: totalDays,
                stripWidth: stripWidth,
              ),
            ],
          );
        },
      ),
    );
  }
}
