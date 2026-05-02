import 'package:atelier/theme/atelier_theme.dart';
import 'package:atelier/theme/atelier_typography.dart';
import 'package:flutter/material.dart';

class DetailCountLabel extends StatelessWidget {
  const DetailCountLabel({
    super.key,
    required this.monthCount,
    required this.yearCount,
  });

  final int monthCount;
  final int yearCount;

  @override
  Widget build(BuildContext context) {
    final p = AtelierTheme.paletteOf(context);
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$monthCount',
            style: AtelierTypography.monoLabel.copyWith(
              color: p.ink,
              fontWeight: FontWeight.w600,
            ),
          ),
          TextSpan(
            text: ' month · ',
            style: AtelierTypography.monoLabel.copyWith(color: p.mute),
          ),
          TextSpan(
            text: '$yearCount',
            style: AtelierTypography.monoLabel.copyWith(
              color: p.ink,
              fontWeight: FontWeight.w600,
            ),
          ),
          TextSpan(
            text: ' year',
            style: AtelierTypography.monoLabel.copyWith(color: p.mute),
          ),
        ],
      ),
    );
  }
}
