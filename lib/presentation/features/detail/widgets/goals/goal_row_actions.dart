import 'package:atelier/presentation/features/detail/widgets/goals/goal_row_action_button.dart';
import 'package:atelier/theme/atelier_spacing.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:flutter/material.dart';

class GoalRowActions extends StatelessWidget {
  const GoalRowActions({
    super.key,
    required this.onEdit,
    required this.onDelete,
  });

  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final p = AtelierTheme.paletteOf(context);
    return Padding(
      padding: const EdgeInsets.only(top: AtelierSpacing.lg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GoalRowActionButton(
            label: 'EDIT',
            onTap: onEdit,
            color: p.sub,
            borderColor: p.rule,
            background: Colors.transparent,
          ),
          const SizedBox(width: AtelierSpacing.base),
          GoalRowActionButton(
            label: 'REMOVE',
            onTap: onDelete,
            color: const Color(0xFFB35454),
            borderColor: p.rule,
            background: Colors.transparent,
          ),
        ],
      ),
    );
  }
}
