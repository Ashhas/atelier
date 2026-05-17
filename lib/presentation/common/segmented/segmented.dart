import 'package:atelier/presentation/common/segmented/segmented_option.dart';
import 'package:atelier/theme/atelier_palette.dart';
import 'package:atelier/theme/atelier_spacing.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:flutter/material.dart';

class Segmented<T> extends StatelessWidget {
  const Segmented({
    super.key,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  /// Nullable so callers can express "no segment active" (e.g. a custom
  /// configuration that doesn't match any preset).
  final T? value;
  final List<SegmentedOptionData<T>> options;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final AtelierPalette p = AtelierTheme.paletteOf(context);
    return Container(
      padding: const EdgeInsets.all(AtelierSpacing.xs),
      decoration: BoxDecoration(
        color: p.surface,
        border: Border.all(color: p.rule),
        borderRadius: BorderRadius.circular(AtelierRadii.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final o in options)
            Expanded(
              child: SegmentedOption<T>(
                data: o,
                active: o.value == value,
                onTap: () => onChanged(o.value),
              ),
            ),
        ],
      ),
    );
  }
}
