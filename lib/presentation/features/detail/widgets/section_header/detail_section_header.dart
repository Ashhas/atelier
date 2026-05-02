import 'package:atelier/theme/atelier_spacing.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:atelier/theme/atelier_typography.dart';
import 'package:flutter/material.dart';

/// "THIS MONTH · MAY" header row that separates the year banner from the goal
/// list on the detail screen.
class DetailSectionHeader extends StatelessWidget {
  const DetailSectionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final p = AtelierTheme.paletteOf(context);
    final now = DateTime.now();
    return Padding(
      padding: const EdgeInsets.only(bottom: AtelierSpacing.base),
      child: Text(
        'THIS MONTH · ${_monthAbbrev(now.month).toUpperCase()}',
        style: AtelierTypography.monoEyebrow.copyWith(color: p.sub),
      ),
    );
  }

  static String _monthAbbrev(int month) {
    const names = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return names[month - 1];
  }
}
