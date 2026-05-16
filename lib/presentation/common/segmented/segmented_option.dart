import 'package:atelier/theme/atelier_palette.dart';
import 'package:atelier/theme/atelier_spacing.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:atelier/theme/atelier_typography.dart';
import 'package:flutter/material.dart';

class SegmentedOptionData<T> {
  const SegmentedOptionData({required this.value, required this.label});
  final T value;
  final String label;
}

class SegmentedOption<T> extends StatelessWidget {
  const SegmentedOption({
    super.key,
    required this.data,
    required this.active,
    required this.onTap,
  });

  final SegmentedOptionData<T> data;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AtelierPalette p = AtelierTheme.paletteOf(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AtelierRadii.md - 1),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AtelierSpacing.lg,
          vertical: AtelierSpacing.base,
        ),
        decoration: BoxDecoration(
          color: active ? p.ink : Colors.transparent,
          borderRadius: BorderRadius.circular(AtelierRadii.md - 1),
        ),
        child: Text(
          data.label,
          textAlign: TextAlign.center,
          style: AtelierTypography.monoLabel.copyWith(
            color: active ? p.bg : p.sub,
          ),
        ),
      ),
    );
  }
}
