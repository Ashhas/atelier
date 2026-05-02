import 'package:atelier/theme/atelier_theme.dart';
import 'package:atelier/theme/atelier_typography.dart';
import 'package:flutter/material.dart';

/// Header row in the settings sheet: "Settings" title + "Close" button.
///
/// Prototype: serif italic 24px on the left, mono "CLOSE" on the right.
class SettingsHeader extends StatelessWidget {
  const SettingsHeader({super.key, required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final c = AtelierTheme.paletteOf(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Expanded(
          child: Text(
            'Settings',
            style: AtelierTypography.serifDisplay.copyWith(color: c.ink),
          ),
        ),
        GestureDetector(
          onTap: onClose,
          child: Text(
            'CLOSE',
            style: AtelierTypography.monoLabel.copyWith(color: c.sub),
          ),
        ),
      ],
    );
  }
}
