import 'package:atelier/presentation/features/detail/widgets/goals/goal_row_editor_button.dart';
import 'package:atelier/theme/atelier_spacing.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:atelier/theme/atelier_typography.dart';
import 'package:atelier/theme/content_font_context.dart';
import 'package:flutter/material.dart';

class GoalRowEditor extends StatefulWidget {
  const GoalRowEditor({
    super.key,
    required this.initialTitle,
    required this.onSave,
    required this.onCancel,
  });

  final String initialTitle;
  final ValueChanged<String> onSave;
  final VoidCallback onCancel;

  @override
  State<GoalRowEditor> createState() => _GoalRowEditorState();
}

class _GoalRowEditorState extends State<GoalRowEditor> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialTitle);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) widget.onSave(text);
  }

  @override
  Widget build(BuildContext context) {
    final p = AtelierTheme.paletteOf(context);
    final font = context.contentFont;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _controller,
          autofocus: true,
          style: AtelierTypography.serifTitleUpright(
            font,
          ).copyWith(color: p.ink),
          decoration: InputDecoration(
            hintText: 'Goal title',
            hintStyle: AtelierTypography.serifTitleUpright(
              font,
            ).copyWith(color: p.mute),
            contentPadding: const EdgeInsets.symmetric(
              vertical: AtelierSpacing.lg,
              horizontal: AtelierSpacing.base + AtelierSpacing.sm,
            ),
            filled: true,
            fillColor: p.bg,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AtelierRadii.md),
              borderSide: BorderSide(color: p.rule),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AtelierRadii.md),
              borderSide: BorderSide(color: p.ruleHi),
            ),
          ),
        ),
        const SizedBox(height: AtelierSpacing.lg),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GoalRowEditorButton(
              label: 'CANCEL',
              onTap: widget.onCancel,
              background: Colors.transparent,
              foreground: p.sub,
              borderColor: p.rule,
            ),
            const SizedBox(width: AtelierSpacing.md),
            GoalRowEditorButton(
              label: 'SAVE',
              onTap: _save,
              background: p.ink,
              foreground: p.bg,
              borderColor: Colors.transparent,
            ),
          ],
        ),
      ],
    );
  }
}
