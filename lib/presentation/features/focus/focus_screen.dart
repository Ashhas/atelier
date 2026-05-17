import 'package:atelier/domain/models/goal.dart';
import 'package:atelier/domain/models/goal_category.dart';
import 'package:atelier/presentation/features/detail/state/goals_cubit.dart';
import 'package:atelier/presentation/features/detail/state/goals_state.dart';
import 'package:atelier/presentation/features/home/state/goal_categories_cubit.dart';
import 'package:atelier/presentation/features/home/state/goal_categories_state.dart';
import 'package:atelier/theme/atelier_spacing.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:atelier/theme/atelier_typography.dart';
import 'package:atelier/utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Focus view — surfaces this month's priorities at a glance.
///
/// Top: starred goals grouped by category. Each card shows the area
/// eyebrow, a row of stars matching the count, and the goal titles in
/// large type. Tap a card to drill into that category's detail screen.
///
/// Bottom: every category that has unstarred goals listed flat — left
/// column shows the area name, right column lists the titles muted.
/// Empty categories show "no goals added".
class FocusScreen extends StatelessWidget {
  const FocusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = AtelierTheme.paletteOf(context);
    final now = DateTime.now();

    return BlocBuilder<GoalCategoriesCubit, GoalCategoriesState>(
      builder: (context, catState) {
        return BlocBuilder<GoalsCubit, GoalsState>(
          builder: (context, goalsState) {
            // Real categories only — drop the synthetic add-slot.
            final realCategories = catState.categories
                .where((c) => !c.isAddSlot)
                .toList(growable: false);
            final allGoals = goalsState.goals;
            final starredCount = allGoals.where((g) => g.starred).length;
            final restCount = allGoals.length - starredCount;

            return Scaffold(
              backgroundColor: p.bg,
              body: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _Header(
                      now: now,
                      starredCount: starredCount,
                      restCount: restCount,
                      onClose: () => context.go('/'),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(
                          AtelierSpacing.x3l,
                          AtelierSpacing.base,
                          AtelierSpacing.x3l,
                          AtelierSpacing.x4l,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _StarredSection(
                              categories: realCategories,
                              goals: allGoals,
                            ),
                            const SizedBox(height: AtelierSpacing.x3l),
                            _EverythingElseSection(
                              categories: realCategories,
                              goals: allGoals,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.now,
    required this.starredCount,
    required this.restCount,
    required this.onClose,
  });

  final DateTime now;
  final int starredCount;
  final int restCount;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final p = AtelierTheme.paletteOf(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AtelierSpacing.x3l,
        AtelierSpacing.xl,
        AtelierSpacing.x3l,
        AtelierSpacing.base,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                AtelierDateUtils.monthName(now.month),
                style: AtelierTypography.serifDisplay.copyWith(color: p.ink),
              ),
              const SizedBox(width: AtelierSpacing.lg),
              Text(
                '${now.year} · FOCUS',
                style: AtelierTypography.monoLabel.copyWith(
                  color: p.mute,
                  fontSize: 10,
                  letterSpacing: 1.4,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: onClose,
                child: Text(
                  'CLOSE',
                  style: AtelierTypography.monoEyebrow.copyWith(
                    color: p.sub,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AtelierSpacing.md),
          Text(
            _subtitle(starredCount, restCount),
            style: AtelierTypography.monoMicro.copyWith(
              color: p.mute,
              letterSpacing: 1.6,
              fontWeight: FontWeight.w600,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }

  String _subtitle(int starred, int rest) {
    return '$starred STARRED · $rest MORE';
  }
}

class _StarredSection extends StatelessWidget {
  const _StarredSection({required this.categories, required this.goals});

  final List<GoalCategory> categories;
  final List<Goal> goals;

  @override
  Widget build(BuildContext context) {
    final p = AtelierTheme.paletteOf(context);
    final starredByCategory = <({GoalCategory cat, List<Goal> items})>[];
    for (final cat in categories) {
      final items = goals
          .where((g) => g.goalCategoryId == cat.id && g.starred)
          .toList(growable: false);
      if (items.isNotEmpty) {
        starredByCategory.add((cat: cat, items: items));
      }
    }

    if (starredByCategory.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AtelierSpacing.x2l,
          vertical: AtelierSpacing.lg + AtelierSpacing.xs,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: p.rule),
          borderRadius: BorderRadius.circular(AtelierRadii.x2l),
        ),
        alignment: Alignment.center,
        child: Text(
          'NO STARRED GOALS YET',
          style: AtelierTypography.monoMicro.copyWith(
            color: p.mute,
            letterSpacing: 1.4,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final entry in starredByCategory) ...[
          _StarredCard(category: entry.cat, items: entry.items),
          const SizedBox(height: AtelierSpacing.base),
        ],
      ],
    );
  }
}

class _StarredCard extends StatelessWidget {
  const _StarredCard({required this.category, required this.items});

  final GoalCategory category;
  final List<Goal> items;

  @override
  Widget build(BuildContext context) {
    final p = AtelierTheme.paletteOf(context);
    return GestureDetector(
      onTap: () => context.go('/pocket/${category.id}'),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          AtelierSpacing.xl,
          AtelierSpacing.lg,
          AtelierSpacing.xl,
          AtelierSpacing.lg,
        ),
        decoration: BoxDecoration(
          color: p.starBg,
          border: Border.all(color: p.starBorder),
          borderRadius: BorderRadius.circular(AtelierRadii.lg + 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Expanded(
                  child: Text(
                    category.name.toUpperCase(),
                    style: AtelierTypography.monoEyebrow.copyWith(
                      color: p.sub,
                      letterSpacing: 1.8,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  '★' * items.length,
                  style: TextStyle(
                    fontSize: 11,
                    letterSpacing: 1,
                    color: p.starInk,
                    height: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AtelierSpacing.md),
            for (final g in items)
              Padding(
                padding: const EdgeInsets.only(bottom: AtelierSpacing.xs),
                child: Text(
                  g.title,
                  style: AtelierTypography.serifTitleUpright.copyWith(
                    color: p.starInk,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    height: 1.25,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _EverythingElseSection extends StatelessWidget {
  const _EverythingElseSection({
    required this.categories,
    required this.goals,
  });

  final List<GoalCategory> categories;
  final List<Goal> goals;

  @override
  Widget build(BuildContext context) {
    final p = AtelierTheme.paletteOf(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'EVERYTHING ELSE',
          style: AtelierTypography.monoEyebrow.copyWith(
            color: p.mute,
            letterSpacing: 1.8,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AtelierSpacing.lg),
        for (final cat in categories) ...[
          _EverythingElseRow(
            category: cat,
            items: goals
                .where((g) => g.goalCategoryId == cat.id && !g.starred)
                .toList(growable: false),
          ),
          const SizedBox(height: AtelierSpacing.lg),
        ],
      ],
    );
  }
}

class _EverythingElseRow extends StatelessWidget {
  const _EverythingElseRow({required this.category, required this.items});

  final GoalCategory category;
  final List<Goal> items;

  @override
  Widget build(BuildContext context) {
    final p = AtelierTheme.paletteOf(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => context.go('/pocket/${category.id}'),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 60,
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                category.name.toUpperCase(),
                style: AtelierTypography.monoMicro.copyWith(
                  color: p.mute,
                  letterSpacing: 1.6,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: AtelierSpacing.lg),
          Expanded(
            child: items.isEmpty
                ? Text(
                    'no goals added',
                    style: AtelierTypography.serifBodyUpright.copyWith(
                      color: p.mute,
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      height: 1.4,
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final g in items)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: Text(
                            g.title,
                            style: AtelierTypography.serifBodyUpright.copyWith(
                              color: p.sub,
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
