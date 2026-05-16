import 'package:atelier/domain/models/year_goal.dart';
import 'package:atelier/theme/atelier_spacing.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:atelier/theme/atelier_typography.dart';
import 'package:flutter/material.dart';

class YearBannerExpanded extends StatefulWidget {
  const YearBannerExpanded({
    super.key,
    required this.yearGoal,
    required this.onToggle,
    required this.onDelete,
    required this.onRename,
  });

  final YearGoal yearGoal;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final ValueChanged<String> onRename;

  @override
  State<YearBannerExpanded> createState() => _YearBannerExpandedState();
}

class _YearBannerExpandedState extends State<YearBannerExpanded> {
  bool _isEditing = false;
  TextEditingController? _controller;

  void _beginEdit() {
    setState(() {
      _controller = TextEditingController(text: widget.yearGoal.title);
      _isEditing = true;
    });
  }

  void _cancelEdit() {
    setState(() {
      _controller?.dispose();
      _controller = null;
      _isEditing = false;
    });
  }

  void _commitEdit() {
    final next = _controller?.text.trim() ?? '';
    if (next.isEmpty) {
      _cancelEdit();
      return;
    }
    if (next != widget.yearGoal.title) widget.onRename(next);
    setState(() {
      _controller?.dispose();
      _controller = null;
      _isEditing = false;
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = AtelierTheme.paletteOf(context);
    final year = DateTime.now().year;
    return GestureDetector(
      // While editing, taps inside the banner shouldn't collapse it.
      onTap: _isEditing ? null : widget.onToggle,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(
          AtelierSpacing.x2l,
          AtelierSpacing.xl,
          AtelierSpacing.x2l,
          AtelierSpacing.x2l,
        ),
        decoration: BoxDecoration(
          color: p.yearBg,
          border: Border.all(color: _isEditing ? p.ink : p.starBorder),
          borderRadius: BorderRadius.circular(AtelierRadii.x2l),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    _isEditing
                        ? '$year · EDITING'
                        : '$year · NORTH STAR',
                    style: AtelierTypography.monoEyebrow.copyWith(color: p.sub),
                  ),
                ),
                if (!_isEditing) ...[
                  _CircleIconButton(
                    glyph: '✎',
                    glyphSize: 11,
                    onTap: _beginEdit,
                    semanticLabel: 'Edit year goal',
                  ),
                  const SizedBox(width: AtelierSpacing.md),
                  _CircleIconButton(
                    glyph: '×',
                    glyphSize: 13,
                    onTap: widget.onDelete,
                    semanticLabel: 'Remove year goal',
                  ),
                ],
              ],
            ),
            const SizedBox(height: AtelierSpacing.base),
            if (_isEditing)
              _TitleEditor(
                controller: _controller!,
                onSubmit: _commitEdit,
                onCancel: _cancelEdit,
              )
            else
              Text(
                widget.yearGoal.title,
                style: AtelierTypography.serifDisplayUpright.copyWith(
                  color: p.ink,
                  fontSize: 20,
                  letterSpacing: -0.4,
                  height: 1.2,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({
    required this.glyph,
    required this.glyphSize,
    required this.onTap,
    required this.semanticLabel,
  });

  final String glyph;
  final double glyphSize;
  final VoidCallback onTap;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final p = AtelierTheme.paletteOf(context);
    return Semantics(
      button: true,
      label: semanticLabel,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: p.chip,
            border: Border.all(color: p.rule),
            borderRadius: BorderRadius.circular(AtelierRadii.pill),
          ),
          alignment: Alignment.center,
          child: Text(
            glyph,
            style: AtelierTypography.monoLabel.copyWith(
              color: p.ink,
              fontWeight: FontWeight.w500,
              fontSize: glyphSize,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }
}

class _TitleEditor extends StatelessWidget {
  const _TitleEditor({
    required this.controller,
    required this.onSubmit,
    required this.onCancel,
  });

  final TextEditingController controller;
  final VoidCallback onSubmit;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final p = AtelierTheme.paletteOf(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: controller,
          autofocus: true,
          minLines: 2,
          maxLines: null,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => onSubmit(),
          style: AtelierTypography.serifDisplayUpright.copyWith(
            color: p.ink,
            fontSize: 19,
            letterSpacing: -0.3,
            height: 1.3,
          ),
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: p.bg,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AtelierSpacing.base + AtelierSpacing.sm,
              vertical: AtelierSpacing.lg,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AtelierRadii.lg),
              borderSide: BorderSide(color: p.rule),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AtelierRadii.lg),
              borderSide: BorderSide(color: p.ruleHi),
            ),
          ),
        ),
        const SizedBox(height: AtelierSpacing.lg),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _PillButton(
              label: 'CANCEL',
              onTap: onCancel,
              background: Colors.transparent,
              foreground: p.sub,
              borderColor: p.rule,
            ),
            const SizedBox(width: AtelierSpacing.md),
            _PillButton(
              label: 'SAVE',
              onTap: onSubmit,
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

class _PillButton extends StatelessWidget {
  const _PillButton({
    required this.label,
    required this.onTap,
    required this.background,
    required this.foreground,
    required this.borderColor,
  });

  final String label;
  final VoidCallback onTap;
  final Color background;
  final Color foreground;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AtelierSpacing.xl,
          vertical: AtelierSpacing.md,
        ),
        decoration: BoxDecoration(
          color: background,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(AtelierRadii.pill),
        ),
        child: Text(
          label,
          style: AtelierTypography.monoLabel.copyWith(
            color: foreground,
            fontSize: 9.5,
            letterSpacing: 1.4,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
