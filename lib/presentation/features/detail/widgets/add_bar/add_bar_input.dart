import 'package:atelier/theme/atelier_spacing.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:atelier/theme/atelier_typography.dart';
import 'package:atelier/theme/content_font_context.dart';
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
    final font = context.contentFont;
    final content = AtelierTypography.serifTitleUpright(font);
    return Expanded(
      child: TextField(
        controller: controller,
        autofocus: true,
        style: content.copyWith(color: p.ink),
        decoration: InputDecoration(
          hintText: placeholder,
          hintStyle: content.copyWith(color: p.sub),
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
