import 'package:atelier/domain/models/goal.dart';
import 'package:atelier/presentation/features/detail/widgets/goals/goal_row_actions.dart';
import 'package:atelier/presentation/features/detail/widgets/goals/goal_row_days_label.dart';
import 'package:atelier/presentation/features/detail/widgets/goals/goal_row_editor.dart';
import 'package:atelier/presentation/features/detail/widgets/goals/goal_row_star_button.dart';
import 'package:atelier/theme/atelier_spacing.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:atelier/theme/atelier_typography.dart';
import 'package:flutter/material.dart';

class GoalRow extends StatefulWidget {
  const GoalRow({
    super.key,
    required this.goal,
    required this.isLast,
    required this.onToggleStar,
    required this.onRename,
    required this.onDelete,
  });

  final Goal goal;
  final bool isLast;
  final VoidCallback onToggleStar;
  final ValueChanged<String> onRename;
  final VoidCallback onDelete;

  @override
  State<GoalRow> createState() => _GoalRowState();
}

class _GoalRowState extends State<GoalRow> {
  bool _isExpanded = false;
  bool _isEditing = false;

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (!_isExpanded) _isEditing = false;
    });
  }

  void _startEditing() {
    setState(() => _isEditing = true);
  }

  void _cancelEditing() {
    setState(() => _isEditing = false);
  }

  void _save(String title) {
    widget.onRename(title);
    setState(() {
      _isEditing = false;
      _isExpanded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = AtelierTheme.paletteOf(context);
    final g = widget.goal;

    final background = g.starred
        ? p.starBg
        : _isExpanded
        ? p.chip
        : Colors.transparent;

    final showDivider = !widget.isLast && !g.starred && !_isExpanded;

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: _isEditing
            ? AtelierSpacing.base + AtelierSpacing.sm
            : AtelierSpacing.x2l,
        horizontal: AtelierSpacing.xl,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(
          g.starred || _isExpanded ? AtelierRadii.xl : 0,
        ),
        border: showDivider ? Border(bottom: BorderSide(color: p.rule)) : null,
      ),
      child: _isEditing
          ? GoalRowEditor(
              initialTitle: g.title,
              onSave: _save,
              onCancel: _cancelEditing,
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _toggleExpanded,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GoalRowStarButton(
                        starred: g.starred,
                        onTap: widget.onToggleStar,
                      ),
                      const SizedBox(width: AtelierSpacing.lg),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              g.title,
                              style: AtelierTypography.serifTitle.copyWith(
                                color: p.ink,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                            GoalRowDaysLabel(addedAt: g.addedAt),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (_isExpanded) ...[
                  Divider(color: p.rule, height: AtelierSpacing.xl),
                  GoalRowActions(
                    onEdit: _startEditing,
                    onDelete: widget.onDelete,
                  ),
                ],
              ],
            ),
    );
  }
}
