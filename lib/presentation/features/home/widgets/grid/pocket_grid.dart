import 'package:atelier/presentation/features/detail/state/goals_cubit.dart';
import 'package:atelier/presentation/features/detail/state/year_goals_cubit.dart';
import 'package:atelier/presentation/features/home/state/goal_categories_cubit.dart';
import 'package:atelier/presentation/features/home/state/manage_mode_cubit.dart';
import 'package:atelier/presentation/features/home/widgets/grid/add_pocket_sheet.dart';
import 'package:atelier/presentation/features/home/widgets/pocket/pocket.dart';
import 'package:atelier/theme/atelier_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

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

    void reorderTo(int from, int to) {
      if (from == to) return;
      final reordered = List.of(visibleCategories);
      final moved = reordered.removeAt(from);
      reordered.insert(to, moved);
      // Only real pocket ids are passed to the cubit; the Open slot is
      // either hidden (manage mode) or handled separately by OpenSlotCreator.
      final realIds = reordered
          .where((c) => !c.isAddSlot)
          .map((c) => c.id)
          .toList();
      categoriesCubit.reorder(realIds);
    }

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
      itemCount: visibleCategories.length,
      itemBuilder: (context, index) {
        final category = visibleCategories[index];
        final pocketYearGoals = yearGoalsState.forCategory(category.id);
        final expanded = pocketYearGoals
            .where((y) => y.expanded)
            .toList(growable: false);
        final collapsed = pocketYearGoals.length - expanded.length;
        final pocket = Pocket(
          key: ValueKey(category.id),
          category: category,
          yearGoalCount: pocketYearGoals.length,
          goalsPreview: goalsState.forCategory(category.id),
          expandedYearGoals: expanded,
          collapsedYearCount: collapsed,
          isManaging: isManaging && !category.isAddSlot,
          onTap: () {
            if (category.isAddSlot) {
              showAddPocketSheet(context, categoriesCubit);
            } else {
              context.push('/pocket/${category.id}');
            }
          },
          onRemove: () => categoriesCubit.removePocket(category.id),
          onLongPress: () {
            if (!category.isAddSlot) manageCubit.enter();
          },
        );

        // Drag-reorder is only active in manage mode and never on the Open
        // add-slot. In manage mode the add-slot is already filtered out of
        // visibleCategories, so checking !isAddSlot is defensive.
        if (!isManaging || category.isAddSlot) return pocket;

        return DragTarget<int>(
          onWillAcceptWithDetails: (d) => d.data != index,
          onAcceptWithDetails: (d) => reorderTo(d.data, index),
          builder: (context, candidate, rejected) {
            return LongPressDraggable<int>(
              data: index,
              feedback: Opacity(
                opacity: 0.85,
                child: Material(
                  color: Colors.transparent,
                  child: SizedBox(
                    width:
                        MediaQuery.of(context).size.width / 2 -
                        AtelierSpacing.x3l -
                        AtelierSpacing.base / 2,
                    child: pocket,
                  ),
                ),
              ),
              childWhenDragging: Opacity(opacity: 0.3, child: pocket),
              child: pocket,
            );
          },
        );
      },
    );
  }
}
