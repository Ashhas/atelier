import 'package:atelier/theme/atelier_spacing.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:atelier/theme/atelier_typography.dart';
import 'package:flutter/material.dart';

/// × remove badge shown at the top-left in manage mode.
///
/// Prototype: position absolute top -6 left -6, width/height 20,
/// borderRadius 10, background ink, color bg, border 2px bg, fontSize 11.
class PocketRemoveBadge extends StatelessWidget {
  const PocketRemoveBadge({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = AtelierTheme.paletteOf(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: c.ink,
          borderRadius: BorderRadius.circular(AtelierSpacing.lg),
          border: Border.all(color: c.bg, width: 2),
        ),
        child: Center(
          child: Text(
            '×',
            style: AtelierTypography.monoMicro.copyWith(
              color: c.bg,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }
}
