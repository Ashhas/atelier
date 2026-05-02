import 'package:atelier/theme/atelier_spacing.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:atelier/theme/atelier_typography.dart';
import 'package:flutter/material.dart';

class GoalsEmptyState extends StatelessWidget {
  const GoalsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final p = AtelierTheme.paletteOf(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AtelierSpacing.x4l),
      child: Center(
        child: Text(
          'Nothing this month yet',
          style: AtelierTypography.monoMicro.copyWith(
            color: p.mute,
            letterSpacing: 1.4,
          ),
        ),
      ),
    );
  }
}
