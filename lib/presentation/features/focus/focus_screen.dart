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
class FocusScreen extends StatefulWidget {
  const FocusScreen({super.key});

  @override
  State<FocusScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends State<FocusScreen>
    with SingleTickerProviderStateMixin {
  // Single controller drives the entire entry sequence. Intervals on
  // child Animation<double>s carve out the per-element segments:
  //   0–260ms     header slides+fades in
  //   ~80ms each  starred cards stagger in (320ms each, ~55ms apart)
  //   trailing    everything-else fades in last
  // The 1000ms total upper-bounds the whole orchestration; intervals
  // map design timings onto that 0..1 line.
  static const _totalMs = 1000;
  late final AnimationController _entry;

  @override
  void initState() {
    super.initState();
    _entry = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: _totalMs),
    )..forward();
  }

  @override
  void dispose() {
    _entry.dispose();
    super.dispose();
  }

  // Interval helper — converts (startMs, endMs) into a 0..1 Animation
  // driven off the master controller with easeOutCubic applied.
  Animation<double> _slice(int startMs, int endMs) => CurvedAnimation(
    parent: _entry,
    curve: Interval(
      startMs / _totalMs,
      endMs / _totalMs,
      curve: Curves.easeOutCubic,
    ),
  );

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

            // Count starred cards so the "everything else" delay knows
            // how many staggered cards precede it.
            final starredCardCount = realCategories
                .where(
                  (cat) => allGoals.any(
                    (g) => g.goalCategoryId == cat.id && g.starred,
                  ),
                )
                .length;
            // 80ms initial + 55ms per card + 80ms after the last card.
            final restStartMs = 80 + starredCardCount * 55 + 80;

            return Scaffold(
              backgroundColor: p.bg,
              body: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _FadeSlide(
                      animation: _slice(0, 260),
                      offset: const Offset(0, -0.04),
                      child: _Header(
                        now: now,
                        starredCount: starredCount,
                        restCount: restCount,
                        onClose: () => context.go('/'),
                      ),
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
                              // Per-card stagger: each card gets its own
                              // interval starting at 80 + i*55ms.
                              cardAnimationBuilder: (i) =>
                                  _slice(80 + i * 55, 80 + i * 55 + 320),
                              emptyAnimation: _slice(80, 80 + 320),
                            ),
                            const SizedBox(height: AtelierSpacing.x3l),
                            _FadeSlide(
                              animation: _slice(restStartMs, restStartMs + 350),
                              offset: const Offset(0, 0.02),
                              child: _EverythingElseSection(
                                categories: realCategories,
                                goals: allGoals,
                              ),
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

/// Fades + slides a child in along [offset] (fractional widget size,
/// matching SlideTransition's semantics) as [animation] progresses 0→1.
/// One reusable wrapper so every element in the focus orchestration
/// reads the same.
class _FadeSlide extends StatelessWidget {
  const _FadeSlide({
    required this.animation,
    required this.offset,
    required this.child,
  });

  final Animation<double> animation;
  final Offset offset;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: offset,
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
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
  const _StarredSection({
    required this.categories,
    required this.goals,
    required this.cardAnimationBuilder,
    required this.emptyAnimation,
  });

  final List<GoalCategory> categories;
  final List<Goal> goals;
  final Animation<double> Function(int index) cardAnimationBuilder;
  final Animation<double> emptyAnimation;

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
      return _FadeSlide(
        animation: emptyAnimation,
        offset: const Offset(0, 0.02),
        child: Container(
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
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final (i, entry) in starredByCategory.indexed) ...[
          _FadeSlide(
            animation: cardAnimationBuilder(i),
            offset: const Offset(0, 0.04),
            child: _StarredCard(category: entry.cat, items: entry.items),
          ),
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
                child: _StarredGoalLine(title: g.title, color: p.starInk),
              ),
          ],
        ),
      ),
    );
  }
}

class _EverythingElseSection extends StatelessWidget {
  const _EverythingElseSection({required this.categories, required this.goals});

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

/// Bullet + title row inside a starred card. The bullet sits in its own
/// fixed-width column so wrapped lines hang to the title's indent rather
/// than tucking under the '•'.
class _StarredGoalLine extends StatelessWidget {
  const _StarredGoalLine({required this.title, required this.color});

  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final style = AtelierTypography.serifTitleUpright.copyWith(
      color: color,
      fontSize: 17,
      fontWeight: FontWeight.w600,
      height: 1.25,
      letterSpacing: -0.3,
    );
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 18, child: Text('•', style: style)),
        Expanded(child: Text(title, style: style)),
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
