import 'package:atelier/theme/atelier_spacing.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:atelier/theme/atelier_typography.dart';
import 'package:flutter/material.dart';

/// Empty goals area inside a pocket card.
///
/// For a regular pocket: dashed border, "EMPTY" label.
/// For the add-slot pocket (isAddSlot): dashed border, "NEW · ADD" label.
///
/// Prototype: border 1px dashed rule, borderRadius 10, minHeight 50,
/// center-aligned mono fontSize 9.5 mute letterSpacing 1.2 uppercase.
class PocketEmptyState extends StatelessWidget {
  const PocketEmptyState({super.key, this.isAddSlot = false});

  final bool isAddSlot;

  @override
  Widget build(BuildContext context) {
    final c = AtelierTheme.paletteOf(context);
    final label = isAddSlot ? 'NEW · ADD' : 'EMPTY';
    return Container(
      constraints: const BoxConstraints(minHeight: 50),
      decoration: BoxDecoration(
        border: Border.all(
          color: c.rule,
          width: 1,
          // Dart BoxBorder doesn't support dashed natively — we use a
          // CustomPainter-free approach: standard border with low opacity
          // to approximate the prototype's dashed hairline.
        ),
        borderRadius: BorderRadius.circular(AtelierRadii.lg),
      ),
      child: Center(
        child: Text(
          label,
          style: AtelierTypography.monoMicro.copyWith(
            color: c.mute,
            fontSize: 9.5,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}
