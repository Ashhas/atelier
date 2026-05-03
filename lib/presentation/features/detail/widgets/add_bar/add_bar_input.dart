import 'package:atelier/theme/atelier_spacing.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:atelier/theme/atelier_typography.dart';
import 'package:flutter/material.dart';

class AddBarInput extends StatelessWidget {
  const AddBarInput({
    super.key,
    required this.controller,
    required this.placeholder,
    required this.onSubmit,
    required this.onCancel,
  });

  final TextEditingController controller;
  final String placeholder;
  final VoidCallback onSubmit;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final p = AtelierTheme.paletteOf(context);
    // Both text and hint use AddBarPlaceholder's mono style so the
    // unfocused → focused transition keeps the same font; only the colour
    // changes (sub/mute for hint, ink for typed input).
    final mono = AtelierTypography.monoLabel.copyWith(letterSpacing: 1.4);
    return Expanded(
      child: TextField(
        controller: controller,
        autofocus: true,
        style: mono.copyWith(color: p.ink),
        decoration: InputDecoration(
          hintText: placeholder,
          hintStyle: mono.copyWith(color: p.sub),
          contentPadding: const EdgeInsets.symmetric(
            vertical: AtelierSpacing.base,
            horizontal: AtelierSpacing.md,
          ),
          border: InputBorder.none,
          isDense: true,
        ),
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => onSubmit(),
        onEditingComplete: onSubmit,
      ),
    );
  }
}
