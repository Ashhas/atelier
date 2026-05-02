import 'package:atelier/domain/models/goal.dart';
import 'package:atelier/domain/models/goal_category.dart';
import 'package:atelier/domain/models/year_goal.dart';
import 'package:atelier/presentation/features/detail/detail_screen.dart';
import 'package:atelier/presentation/features/detail/state/goals_cubit.dart';
import 'package:atelier/presentation/features/detail/state/goals_state.dart';
import 'package:atelier/presentation/features/detail/state/year_goals_cubit.dart';
import 'package:atelier/presentation/features/detail/state/year_goals_state.dart';
import 'package:atelier/presentation/features/detail/widgets/add_bar/add_bar.dart';
import 'package:atelier/presentation/features/detail/widgets/goals/goals_empty_state.dart';
import 'package:atelier/presentation/features/detail/widgets/top_bar/detail_top_bar.dart';
import 'package:atelier/presentation/features/detail/widgets/year_banner/year_banner.dart';
import 'package:atelier/presentation/features/home/state/goal_categories_cubit.dart';
import 'package:atelier/presentation/features/home/state/goal_categories_state.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class _MockGoalsCubit extends Mock implements GoalsCubit {}

class _MockYearGoalsCubit extends Mock implements YearGoalsCubit {}

class _MockGoalCategoriesCubit extends Mock implements GoalCategoriesCubit {}

Widget _wrap({
  required GoalsCubit goals,
  required YearGoalsCubit yearGoals,
  required GoalCategoriesCubit categories,
}) {
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (_, __) => MultiBlocProvider(
          providers: [
            BlocProvider<GoalsCubit>.value(value: goals),
            BlocProvider<YearGoalsCubit>.value(value: yearGoals),
            BlocProvider<GoalCategoriesCubit>.value(value: categories),
          ],
          child: const DetailScreen(goalCategoryId: 'cat1'),
        ),
      ),
    ],
  );
  return MaterialApp.router(theme: AtelierTheme.light(), routerConfig: router);
}

void main() {
  late _MockGoalsCubit goalsCubit;
  late _MockYearGoalsCubit yearGoalsCubit;
  late _MockGoalCategoriesCubit categoriesCubit;

  const testCategory = GoalCategory(id: 'cat1', name: 'Body', order: 0);

  final testGoal = Goal(
    id: 'g1',
    goalCategoryId: 'cat1',
    title: 'Sub-25 5K',
    addedAt: DateTime.now(),
  );

  const testYearGoal = YearGoal(
    id: 'yg1',
    goalCategoryId: 'cat1',
    title: 'Run a marathon',
    expanded: true,
  );

  setUp(() {
    goalsCubit = _MockGoalsCubit();
    yearGoalsCubit = _MockYearGoalsCubit();
    categoriesCubit = _MockGoalCategoriesCubit();

    when(() => goalsCubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => yearGoalsCubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => categoriesCubit.stream).thenAnswer((_) => const Stream.empty());
  });

  group('DetailScreen', () {
    testWidgets('renders DetailTopBar, YearBanner and AddBar', (tester) async {
      when(() => categoriesCubit.state).thenReturn(
        const GoalCategoriesState(categories: [testCategory], loaded: true),
      );
      when(
        () => goalsCubit.state,
      ).thenReturn(GoalsState(goals: [testGoal], loaded: true));
      when(() => yearGoalsCubit.state).thenReturn(
        const YearGoalsState(yearGoals: [testYearGoal], loaded: true),
      );

      await tester.pumpWidget(
        _wrap(
          goals: goalsCubit,
          yearGoals: yearGoalsCubit,
          categories: categoriesCubit,
        ),
      );
      await tester.pump();

      expect(find.byType(DetailTopBar), findsOneWidget);
      expect(find.byType(YearBanner), findsOneWidget);
      expect(find.byType(AddBar), findsOneWidget);
    });

    testWidgets('shows GoalsEmptyState when no goals', (tester) async {
      when(() => categoriesCubit.state).thenReturn(
        const GoalCategoriesState(categories: [testCategory], loaded: true),
      );
      when(() => goalsCubit.state).thenReturn(const GoalsState(loaded: true));
      when(
        () => yearGoalsCubit.state,
      ).thenReturn(const YearGoalsState(loaded: true));

      await tester.pumpWidget(
        _wrap(
          goals: goalsCubit,
          yearGoals: yearGoalsCubit,
          categories: categoriesCubit,
        ),
      );
      await tester.pump();

      expect(find.byType(GoalsEmptyState), findsOneWidget);
    });

    testWidgets('shows category name from GoalCategoriesCubit', (tester) async {
      when(() => categoriesCubit.state).thenReturn(
        const GoalCategoriesState(categories: [testCategory], loaded: true),
      );
      when(() => goalsCubit.state).thenReturn(const GoalsState(loaded: true));
      when(
        () => yearGoalsCubit.state,
      ).thenReturn(const YearGoalsState(loaded: true));

      await tester.pumpWidget(
        _wrap(
          goals: goalsCubit,
          yearGoals: yearGoalsCubit,
          categories: categoriesCubit,
        ),
      );
      await tester.pump();

      expect(find.text('Body'), findsWidgets);
    });

    testWidgets('renders one YearBanner per year goal', (tester) async {
      const ygOne = YearGoal(
        id: 'yg1',
        goalCategoryId: 'cat1',
        title: 'Run a marathon',
      );
      const ygTwo = YearGoal(
        id: 'yg2',
        goalCategoryId: 'cat1',
        title: 'Lift 100kg',
      );
      const ygThree = YearGoal(
        id: 'yg3',
        goalCategoryId: 'cat1',
        title: 'Swim 1km',
      );

      when(() => categoriesCubit.state).thenReturn(
        const GoalCategoriesState(categories: [testCategory], loaded: true),
      );
      when(() => goalsCubit.state).thenReturn(const GoalsState(loaded: true));
      when(() => yearGoalsCubit.state).thenReturn(
        const YearGoalsState(loaded: true, yearGoals: [ygOne, ygTwo, ygThree]),
      );

      await tester.pumpWidget(
        _wrap(
          goals: goalsCubit,
          yearGoals: yearGoalsCubit,
          categories: categoriesCubit,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(YearBanner), findsNWidgets(3));
      expect(find.text('Run a marathon'), findsOneWidget);
      expect(find.text('Lift 100kg'), findsOneWidget);
      expect(find.text('Swim 1km'), findsOneWidget);
    });

    testWidgets('shows empty-state YearBanner when there are zero year goals', (
      tester,
    ) async {
      when(() => categoriesCubit.state).thenReturn(
        const GoalCategoriesState(categories: [testCategory], loaded: true),
      );
      when(() => goalsCubit.state).thenReturn(const GoalsState(loaded: true));
      when(
        () => yearGoalsCubit.state,
      ).thenReturn(const YearGoalsState(loaded: true));

      await tester.pumpWidget(
        _wrap(
          goals: goalsCubit,
          yearGoals: yearGoalsCubit,
          categories: categoriesCubit,
        ),
      );
      await tester.pumpAndSettle();

      // Exactly one YearBanner is rendered (the empty-state variant).
      expect(find.byType(YearBanner), findsOneWidget);
    });
  });
}
