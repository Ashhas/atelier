import 'package:atelier/theme/atelier_theme.dart';
import 'package:atelier/theme/atelier_typography.dart';
import 'package:flutter/material.dart';

/// "BLANK SLATE" eyebrow label for the empty state (spec §3.9).
class HomeEmptyStateEyebrow extends StatelessWidget {
  const HomeEmptyStateEyebrow({super.key});

  @override
  Widget build(BuildContext context) {
    final c = AtelierTheme.paletteOf(context);
    return Text(
      'BLANK SLATE',
      style: AtelierTypography.monoEyebrow.copyWith(color: c.mute),
      textAlign: TextAlign.center,
    );
  }
}
