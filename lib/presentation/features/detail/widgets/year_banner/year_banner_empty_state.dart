import 'package:atelier/theme/atelier_spacing.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:atelier/theme/atelier_typography.dart';
import 'package:flutter/material.dart';

class YearBannerEmptyState extends StatelessWidget {
  const YearBannerEmptyState({super.key, required this.categoryName});

  final String categoryName;

  @override
  Widget build(BuildContext context) {
    final p = AtelierTheme.paletteOf(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: AtelierSpacing.xl,
        horizontal: AtelierSpacing.x2l,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: p.rule, style: BorderStyle.solid, width: 1),
        borderRadius: BorderRadius.circular(AtelierRadii.x2l),
      ),
      child: Text(
        'No ${DateTime.now().year} goal yet for $categoryName',
        textAlign: TextAlign.center,
        style: AtelierTypography.monoMicro.copyWith(
          color: p.mute,
          letterSpacing: 1.4,
        ),
      ),
    );
  }
}
