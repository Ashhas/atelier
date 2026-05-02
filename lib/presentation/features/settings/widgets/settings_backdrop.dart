import 'package:flutter/material.dart';

/// Semi-transparent scrim behind the settings sheet.
///
/// Prototype: rgba(0,0,0,0.35). Tapping it closes the sheet.
class SettingsBackdrop extends StatelessWidget {
  const SettingsBackdrop({super.key, required this.onDismiss});

  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onDismiss,
      child: Container(color: Colors.black.withValues(alpha: 0.35)),
    );
  }
}
