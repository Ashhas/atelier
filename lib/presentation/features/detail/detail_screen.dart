import 'package:atelier/presentation/features/detail/state/goals_cubit.dart';
import 'package:atelier/presentation/features/detail/state/year_goals_cubit.dart';
import 'package:atelier/presentation/features/detail/widgets/add_bar/add_bar.dart';
import 'package:atelier/presentation/features/detail/widgets/goals/goal_row.dart';
import 'package:atelier/presentation/features/detail/widgets/goals/goals_empty_state.dart';
import 'package:atelier/presentation/features/detail/widgets/section_header/detail_section_header.dart';
import 'package:atelier/presentation/features/detail/widgets/top_bar/detail_top_bar.dart';
import 'package:atelier/presentation/features/detail/widgets/year_banner/year_banner.dart';
import 'package:atelier/presentation/features/home/state/goal_categories_cubit.dart';
import 'package:atelier/theme/atelier_spacing.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.goalCategoryId});

  final String goalCategoryId;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  String? _expandedGoalId;

  void _toggleExpandedGoal(String id) {
    setState(() {
      _expandedGoalId = _expandedGoalId == id ? null : id;
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = AtelierTheme.paletteOf(context);
    final goalCategoryId = widget.goalCategoryId;

    final categoriesState = context.watch<GoalCategoriesCubit>().state;
    final goalsState = context.watch<GoalsCubit>().state;
    final yearGoalsState = context.watch<YearGoalsCubit>().state;

    final category = categoriesState.categories.firstWhereOrNull(
      (c) => c.id == goalCategoryId,
    );
    final categoryName = category?.name ?? goalCategoryId;

    final goals = goalsState.forCategory(goalCategoryId);
    final yearGoals = yearGoalsState.forCategory(goalCategoryId);

    return Scaffold(
      backgroundColor: p.bg,
      body: SafeArea(
        child: Column(
          children: [
            DetailTopBar(
              name: categoryName,
              monthCount: goals.length,
              yearCount: yearGoals.length,
              onBack: () => context.canPop() ? context.pop() : context.go('/'),
            ),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  // Year banners + section header in a non-reorderable
                  // sliver above the draggable goals list.
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      AtelierSpacing.xl,
                      0,
                      AtelierSpacing.xl,
                      0,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        if (yearGoals.isEmpty)
                          YearBanner(
                            yearGoal: null,
                            categoryName: categoryName,
                            onToggle: (id) => context
                                .read<YearGoalsCubit>()
                                .toggleExpanded(id),
                            onDelete: (id) =>
                                context.read<YearGoalsCubit>().delete(id),
                            onRename: (id, title) => context
                                .read<YearGoalsCubit>()
                                .rename(id: id, title: title),
                          )
                        else
                          for (final yg in yearGoals) ...[
                            YearBanner(
                              key: ValueKey(yg.id),
                              yearGoal: yg,
                              categoryName: categoryName,
                              onToggle: (id) => context
                                  .read<YearGoalsCubit>()
                                  .toggleExpanded(id),
                              onDelete: (id) =>
                                  context.read<YearGoalsCubit>().delete(id),
                              onRename: (id, title) => context
                                  .read<YearGoalsCubit>()
                                  .rename(id: id, title: title),
                            ),
                            const SizedBox(height: AtelierSpacing.base),
                          ],
                        const SizedBox(
                          height: AtelierSpacing.xl + AtelierSpacing.md,
                        ),
                        const DetailSectionHeader(),
                        if (goals.isEmpty) const GoalsEmptyState(),
                      ]),
                    ),
                  ),
                  // Drag start is delayed (~500ms) so the row's own tap
                  // handlers (expand, star, edit) still fire on short
                  // presses — only long-presses initiate a reorder.
                  if (goals.isNotEmpty)
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AtelierSpacing.xl,
                      ),
                      sliver: SliverReorderableList(
                        itemCount: goals.length,
                        itemBuilder: (context, index) {
                          final g = goals[index];
                          return ReorderableDelayedDragStartListener(
                            key: ValueKey(g.id),
                            index: index,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                bottom: AtelierSpacing.sm,
                              ),
                              child: GoalRow(
                                goal: g,
                                isExpanded: _expandedGoalId == g.id,
                                onToggleExpanded: () =>
                                    _toggleExpandedGoal(g.id),
                                onToggleStar: () =>
                                    context.read<GoalsCubit>().toggleStar(g.id),
                                onRename: (title) =>
                                    context.read<GoalsCubit>().rename(
                                      id: g.id,
                                      title: title,
                                    ),
                                onDelete: () =>
                                    context.read<GoalsCubit>().delete(g.id),
                              ),
                            ),
                          );
                        },
                        onReorder: (oldIndex, newIndex) {
                          // ReorderableList's newIndex semantics: when
                          // dragging down, newIndex is one past the target
                          // slot. Normalise to a "move from A to B" model.
                          var dest = newIndex;
                          if (newIndex > oldIndex) dest -= 1;
                          final ids = goals.map((g) => g.id).toList();
                          final moved = ids.removeAt(oldIndex);
                          ids.insert(dest, moved);
                          context.read<GoalsCubit>().reorder(
                            goalCategoryId: goalCategoryId,
                            orderedIds: ids,
                          );
                        },
                      ),
                    ),
                  // Bottom padding so the last row clears the AddBar.
                  const SliverToBoxAdapter(
                    child: SizedBox(
                      height: AtelierSpacing.x4l + AtelierSpacing.x2l,
                    ),
                  ),
                ],
              ),
            ),
            AddBar(goalCategoryId: goalCategoryId),
          ],
        ),
      ),
    );
  }
}
