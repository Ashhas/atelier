import 'package:atelier/theme/atelier_spacing.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:atelier/theme/atelier_typography.dart';
import 'package:flutter/material.dart';

class ExportDataButton extends StatelessWidget {
  const ExportDataButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = AtelierTheme.paletteOf(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AtelierSpacing.x2l),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: c.rule),
          borderRadius: BorderRadius.circular(AtelierRadii.x2l),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Export data',
              style: AtelierTypography.sansLabel.copyWith(color: c.ink),
            ),
            const SizedBox(height: AtelierSpacing.xs),
            Text(
              'Share your goals as a JSON file — Drive, Files, Mail, …',
              style: AtelierTypography.sansBody.copyWith(color: c.sub),
            ),
          ],
        ),
      ),
    );
  }
}
