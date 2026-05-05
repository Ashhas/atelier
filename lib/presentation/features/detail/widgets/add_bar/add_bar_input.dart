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
    final content = AtelierTypography.serifTitleUpright;
    return Expanded(
      child: TextField(
        controller: controller,
        autofocus: true,
        style: content.copyWith(color: p.ink),
        decoration: InputDecoration(
          hintText: placeholder,
          // Hint a touch smaller than the typed text so it reads as a
          // placeholder rather than competing with what the user types.
          hintStyle: content.copyWith(color: p.sub, fontSize: 14),
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
