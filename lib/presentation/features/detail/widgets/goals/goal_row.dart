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
    required this.isExpanded,
    required this.onToggleExpanded,
    required this.onToggleStar,
    required this.onRename,
    required this.onDelete,
  });

  final Goal goal;
  final bool isExpanded;
  final VoidCallback onToggleExpanded;
  final VoidCallback onToggleStar;
  final ValueChanged<String> onRename;
  final VoidCallback onDelete;

  @override
  State<GoalRow> createState() => _GoalRowState();
}

class _GoalRowState extends State<GoalRow> {
  bool _isEditing = false;

  @override
  void didUpdateWidget(covariant GoalRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Parent collapsed us (e.g. another row was opened) — drop edit mode too.
    if (oldWidget.isExpanded && !widget.isExpanded && _isEditing) {
      _isEditing = false;
    }
  }

  void _startEditing() {
    setState(() => _isEditing = true);
  }

  void _cancelEditing() {
    setState(() => _isEditing = false);
  }

  void _save(String title) {
    widget.onRename(title);
    setState(() => _isEditing = false);
    if (widget.isExpanded) widget.onToggleExpanded();
  }

  @override
  Widget build(BuildContext context) {
    final p = AtelierTheme.paletteOf(context);
    final g = widget.goal;

    final isExpanded = widget.isExpanded;
    final background = g.starred
        ? p.starBg
        : isExpanded
        ? p.chip
        : Colors.transparent;

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
          g.starred || isExpanded ? AtelierRadii.xl : 0,
        ),
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
                  onTap: widget.onToggleExpanded,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                              style: AtelierTypography.serifTitleUpright
                                  .copyWith(color: p.ink),
                            ),
                            GoalRowDaysLabel(addedAt: g.addedAt),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (isExpanded) ...[
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
