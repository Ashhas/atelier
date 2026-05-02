import 'package:atelier/domain/models/goal_category.dart';
import 'package:atelier/presentation/features/home/state/goal_categories_cubit.dart';
import 'package:atelier/presentation/features/home/state/goal_categories_state.dart';
import 'package:atelier/presentation/features/home/state/manage_mode_cubit.dart';
import 'package:atelier/presentation/features/home/state/manage_mode_state.dart';
import 'package:atelier/presentation/features/home/widgets/pocket/pocket.dart';
import 'package:atelier/theme/atelier_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

/// 2-column reorderable grid of pocket cards, driven by [GoalCategoriesCubit].
///
/// The Open add-slot pocket is hidden during manage mode (spec §3.6).
/// Drag-reorder triggers [GoalCategoriesCubit.reorder] with the new real-id order.
///
/// Prototype: 2-column grid, gap 8, padding 4 22 20.
class PocketGrid extends StatelessWidget {
  const PocketGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GoalCategoriesCubit, GoalCategoriesState>(
      builder: (context, catState) {
        return BlocBuilder<ManageModeCubit, ManageModeState>(
          builder: (context, manageState) {
            final isManaging = manageState.isManaging;

            // In manage mode the Open add-slot is hidden (spec §3.6)
            final visibleCategories = isManaging
                ? catState.categories.where((c) => !c.isAddSlot).toList()
                : catState.categories;

            final categoriesCubit = context.read<GoalCategoriesCubit>();
            final manageCubit = context.read<ManageModeCubit>();

            return ReorderableGridView.count(
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
              childAspectRatio: 0.88,
              dragEnabled: isManaging,
              onReorder: (int oldIndex, int newIndex) {
                final reordered = List<GoalCategory>.from(visibleCategories);
                final moved = reordered.removeAt(oldIndex);
                reordered.insert(newIndex, moved);
                // Only pass the real (non-add-slot) ids in new order
                final realIds = reordered
                    .where((c) => !c.isAddSlot)
                    .map((c) => c.id)
                    .toList();
                categoriesCubit.reorder(realIds);
              },
              children: [
                for (final category in visibleCategories)
                  Pocket(
                    key: ValueKey(category.id),
                    category: category,
                    yearGoalCount: 0,
                    goalsPreview: const [],
                    isManaging: isManaging && !category.isAddSlot,
                    onTap: () {
                      // Navigation to detail (to be wired by HomeScreen)
                    },
                    onRemove: () => categoriesCubit.removePocket(category.id),
                    onLongPress: () {
                      if (!category.isAddSlot) manageCubit.enter();
                    },
                  ),
              ],
            );
          },
        );
      },
    );
  }
}
