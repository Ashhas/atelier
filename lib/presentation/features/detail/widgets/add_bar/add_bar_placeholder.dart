import 'package:atelier/theme/atelier_spacing.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:atelier/theme/atelier_typography.dart';
import 'package:atelier/theme/content_font_context.dart';
import 'package:flutter/material.dart';

class AddBarPlaceholder extends StatelessWidget {
  const AddBarPlaceholder({
    super.key,
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = AtelierTheme.paletteOf(context);
    final font = context.contentFont;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AtelierSpacing.base,
            horizontal: AtelierSpacing.md,
          ),
          child: Text(
            label,
            style: AtelierTypography.serifTitleUpright(
              font,
            ).copyWith(color: p.sub),
          ),
        ),
      ),
    );
  }
}
