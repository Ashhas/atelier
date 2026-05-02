import 'package:atelier/presentation/features/detail/state/goals_cubit.dart';
import 'package:atelier/presentation/features/detail/state/year_goals_cubit.dart';
import 'package:atelier/presentation/features/home/state/goal_categories_cubit.dart';
import 'package:atelier/presentation/features/home/state/manage_mode_cubit.dart';
import 'package:atelier/presentation/features/home/widgets/pocket/pocket.dart';
import 'package:atelier/theme/atelier_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

void _showAddPocketSheet(BuildContext context, GoalCategoriesCubit cubit) {
  final controller = TextEditingController();
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (sheetContext) {
      return Padding(
        padding: EdgeInsets.only(
          left: AtelierSpacing.x3l,
          right: AtelierSpacing.x3l,
          top: AtelierSpacing.x3l,
          bottom:
              MediaQuery.of(sheetContext).viewInsets.bottom +
              AtelierSpacing.x3l,
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                autofocus: true,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(hintText: 'New pocket name…'),
                onSubmitted: (_) {
                  final name = controller.text.trim();
                  if (name.isNotEmpty) cubit.addPocket(name);
                  Navigator.of(sheetContext).pop();
                },
              ),
            ),
            const SizedBox(width: AtelierSpacing.base),
            TextButton(
              onPressed: () {
                final name = controller.text.trim();
                if (name.isNotEmpty) cubit.addPocket(name);
                Navigator.of(sheetContext).pop();
              },
              child: const Text('ADD'),
            ),
          ],
        ),
      );
    },
  );
}

/// 2-column masonry grid of pocket cards, driven by [GoalCategoriesCubit].
///
/// Tile height adapts to the content of each pocket (variable per tile),
/// so a sparse pocket and a full pocket can sit side-by-side without
/// wasted space or overflow. The Open add-slot pocket is hidden during
/// manage mode (spec §3.6).
///
/// Prototype: 2-column grid, gap 8, padding 4 22 20.
class PocketGrid extends StatelessWidget {
  const PocketGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final catState = context.watch<GoalCategoriesCubit>().state;
    final manageState = context.watch<ManageModeCubit>().state;
    final goalsState = context.watch<GoalsCubit>().state;
    final yearGoalsState = context.watch<YearGoalsCubit>().state;

    final isManaging = manageState.isManaging;

    // In manage mode the Open add-slot is hidden (spec §3.6).
    final visibleCategories = isManaging
        ? catState.categories.where((c) => !c.isAddSlot).toList()
        : catState.categories;

    final categoriesCubit = context.read<GoalCategoriesCubit>();
    final manageCubit = context.read<ManageModeCubit>();

    return MasonryGridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: AtelierSpacing.base, // 8
      crossAxisSpacing: AtelierSpacing.base, // 8
      padding: const EdgeInsets.fromLTRB(
        AtelierSpacing.x3l, // 22
        AtelierSpacing.sm, // 4
        AtelierSpacing.x3l, // 22
        20,
      ),
      shrinkWrap: true,
      itemCount: visibleCategories.length,
      itemBuilder: (context, index) {
        final category = visibleCategories[index];
        final pocketYearGoals = yearGoalsState.forCategory(category.id);
        final expanded = pocketYearGoals
            .where((y) => y.expanded)
            .toList(growable: false);
        final collapsed = pocketYearGoals.length - expanded.length;
        return Pocket(
          key: ValueKey(category.id),
          category: category,
          yearGoalCount: pocketYearGoals.length,
          goalsPreview: goalsState.forCategory(category.id),
          expandedYearGoals: expanded,
          collapsedYearCount: collapsed,
          isManaging: isManaging && !category.isAddSlot,
          onTap: () {
            if (category.isAddSlot) {
              _showAddPocketSheet(context, categoriesCubit);
            } else {
              context.push('/pocket/${category.id}');
            }
          },
          onRemove: () => categoriesCubit.removePocket(category.id),
          onLongPress: () {
            if (!category.isAddSlot) manageCubit.enter();
          },
        );
      },
    );
  }
}
