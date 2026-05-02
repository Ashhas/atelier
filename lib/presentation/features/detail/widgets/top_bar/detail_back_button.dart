import 'package:atelier/theme/atelier_spacing.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:atelier/theme/atelier_typography.dart';
import 'package:flutter/material.dart';

class DetailBackButton extends StatelessWidget {
  const DetailBackButton({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final p = AtelierTheme.paletteOf(context);
    return GestureDetector(
      onTap: onBack,
      child: Padding(
        padding: const EdgeInsets.only(right: AtelierSpacing.sm),
        child: Text(
          '←',
          style: AtelierTypography.monoLabel.copyWith(
            color: p.sub,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
