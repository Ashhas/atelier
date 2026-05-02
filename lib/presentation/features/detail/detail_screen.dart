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

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.goalCategoryId});

  final String goalCategoryId;

  @override
  Widget build(BuildContext context) {
    final p = AtelierTheme.paletteOf(context);

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
              child: ListView(
                padding: const EdgeInsets.only(
                  left: AtelierSpacing.x3l,
                  right: AtelierSpacing.x3l,
                  bottom: AtelierSpacing.x4l,
                ),
                children: [
                  if (yearGoals.isEmpty)
                    YearBanner(
                      yearGoal: null,
                      categoryName: categoryName,
                      onToggle: (id) =>
                          context.read<YearGoalsCubit>().toggleExpanded(id),
                      onDelete: (id) =>
                          context.read<YearGoalsCubit>().delete(id),
                    )
                  else
                    for (final yg in yearGoals) ...[
                      YearBanner(
                        key: ValueKey(yg.id),
                        yearGoal: yg,
                        categoryName: categoryName,
                        onToggle: (id) =>
                            context.read<YearGoalsCubit>().toggleExpanded(id),
                        onDelete: (id) =>
                            context.read<YearGoalsCubit>().delete(id),
                      ),
                      const SizedBox(height: AtelierSpacing.base),
                    ],
                  const SizedBox(height: AtelierSpacing.xl + AtelierSpacing.md),
                  const DetailSectionHeader(),
                  if (goals.isEmpty)
                    const GoalsEmptyState()
                  else
                    ...goals.asMap().entries.map(
                      (e) => GoalRow(
                        key: ValueKey(e.value.id),
                        goal: e.value,
                        isLast: e.key == goals.length - 1,
                        onToggleStar: () =>
                            context.read<GoalsCubit>().toggleStar(e.value.id),
                        onRename: (title) => context.read<GoalsCubit>().rename(
                          id: e.value.id,
                          title: title,
                        ),
                        onDelete: () =>
                            context.read<GoalsCubit>().delete(e.value.id),
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
