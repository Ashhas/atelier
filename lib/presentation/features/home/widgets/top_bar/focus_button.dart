import 'package:atelier/theme/atelier_spacing.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:flutter/material.dart';

/// Circular focus-view button (≣) with hairline rule border, sat
/// immediately left of the settings gear in the home top bar.
///
/// Prototype: width/height 26, borderRadius 999, border 1px rule.
/// Glyph is ink-coloured (the gear is sub) so the focus button reads as
/// the primary action of the pair.
class FocusButton extends StatelessWidget {
  const FocusButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = AtelierTheme.paletteOf(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AtelierSpacing.x3l + AtelierSpacing.sm, // 26
        height: AtelierSpacing.x3l + AtelierSpacing.sm, // 26
        decoration: BoxDecoration(
          color: c.bg,
          border: Border.all(color: c.rule),
          borderRadius: BorderRadius.circular(AtelierRadii.pill),
        ),
        child: Center(
          child: Text(
            '≣',
            style: TextStyle(
              fontSize: 13,
              color: c.ink,
              height: 1,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
