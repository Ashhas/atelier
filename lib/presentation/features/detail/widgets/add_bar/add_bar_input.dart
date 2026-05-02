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
    return Expanded(
      child: TextField(
        controller: controller,
        autofocus: true,
        style: AtelierTypography.serifTitle.copyWith(
          color: p.ink,
          fontStyle: FontStyle.italic,
        ),
        decoration: InputDecoration(
          hintText: placeholder,
          hintStyle: AtelierTypography.serifTitle.copyWith(
            color: p.mute,
            fontStyle: FontStyle.italic,
          ),
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
