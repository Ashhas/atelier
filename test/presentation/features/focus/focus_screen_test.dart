import 'package:atelier/domain/models/goal.dart';
import 'package:atelier/domain/models/goal_category.dart';
import 'package:atelier/presentation/features/detail/state/goals_cubit.dart';
import 'package:atelier/presentation/features/detail/state/goals_state.dart';
import 'package:atelier/presentation/features/focus/focus_screen.dart';
import 'package:atelier/presentation/features/home/state/goal_categories_cubit.dart';
import 'package:atelier/presentation/features/home/state/goal_categories_state.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class _MockGoalsCubit extends Mock implements GoalsCubit {}

class _MockGoalCategoriesCubit extends Mock implements GoalCategoriesCubit {}

const _body = GoalCategory(id: 'body', name: 'Body', order: 0);
const _mind = GoalCategory(id: 'mind', name: 'Mind', order: 1);
const _addSlot = GoalCategory(
  id: 'open',
  name: 'New',
  order: 2,
  isAddSlot: true,
);

Goal _g(
  String id,
  String catId,
  String title, {
  bool starred = false,
}) => Goal(
  id: id,
  goalCategoryId: catId,
  title: title,
  starred: starred,
  addedAt: DateTime(2026, 5, 1),
);

Widget _wrap({
  required GoalsCubit goalsCubit,
  required GoalCategoriesCubit catsCubit,
}) {
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (_, __) => MultiBlocProvider(
          providers: [
            BlocProvider<GoalsCubit>.value(value: goalsCubit),
            BlocProvider<GoalCategoriesCubit>.value(value: catsCubit),
          ],
          child: const FocusScreen(),
        ),
      ),
      GoRoute(path: '/pocket/:id', builder: (_, __) => const SizedBox()),
    ],
  );
  return MaterialApp.router(theme: AtelierTheme.light(), routerConfig: router);
}

void main() {
  late _MockGoalsCubit goals;
  late _MockGoalCategoriesCubit cats;

  setUp(() {
    goals = _MockGoalsCubit();
    cats = _MockGoalCategoriesCubit();
    when(() => goals.stream).thenAnswer((_) => const Stream.empty());
    when(() => cats.stream).thenAnswer((_) => const Stream.empty());
  });

  group('FocusScreen', () {
    testWidgets('renders header, star count, and starred goal titles', (
      tester,
    ) async {
      when(() => cats.state).thenReturn(
        const GoalCategoriesState(
          loaded: true,
          categories: [_body, _mind, _addSlot],
        ),
      );
      when(() => goals.state).thenReturn(
        GoalsState(
          loaded: true,
          goals: [
            _g('1', 'body', 'Sub-25 5K', starred: true),
            _g('2', 'body', 'Strength 3×/wk'),
            _g('3', 'mind', 'Read 20m before bed', starred: true),
          ],
        ),
      );

      await tester.pumpWidget(_wrap(goalsCubit: goals, catsCubit: cats));
      await tester.pumpAndSettle();

      expect(find.text('2 STARRED · 1 MORE'), findsOneWidget);
      expect(find.text('Sub-25 5K'), findsOneWidget);
      expect(find.text('Read 20m before bed'), findsOneWidget);
      // Unstarred goal goes into the everything-else list, not the cards.
      expect(find.text('Strength 3×/wk'), findsOneWidget);
      expect(find.text('EVERYTHING ELSE'), findsOneWidget);
    });

    testWidgets('shows empty state when no goals are starred', (tester) async {
      when(() => cats.state).thenReturn(
        const GoalCategoriesState(loaded: true, categories: [_body, _addSlot]),
      );
      when(() => goals.state).thenReturn(
        GoalsState(loaded: true, goals: [_g('1', 'body', 'Sub-25 5K')]),
      );

      await tester.pumpWidget(_wrap(goalsCubit: goals, catsCubit: cats));
      await tester.pumpAndSettle();

      expect(find.text('NO STARRED GOALS YET'), findsOneWidget);
    });

    testWidgets('hides the synthetic add-slot category from the focus list', (
      tester,
    ) async {
      when(() => cats.state).thenReturn(
        const GoalCategoriesState(loaded: true, categories: [_body, _addSlot]),
      );
      when(() => goals.state).thenReturn(
        const GoalsState(loaded: true, goals: []),
      );

      await tester.pumpWidget(_wrap(goalsCubit: goals, catsCubit: cats));
      await tester.pumpAndSettle();

      // BODY appears (real category); NEW (the add-slot's render name)
      // must not appear anywhere — including in EVERYTHING ELSE.
      expect(find.text('BODY'), findsOneWidget);
      expect(find.text('NEW'), findsNothing);
    });

    testWidgets('"everything else" row labels show "no goals added" when empty', (
      tester,
    ) async {
      when(() => cats.state).thenReturn(
        const GoalCategoriesState(loaded: true, categories: [_body, _addSlot]),
      );
      when(() => goals.state).thenReturn(
        GoalsState(
          loaded: true,
          goals: [_g('1', 'body', 'Sub-25 5K', starred: true)],
        ),
      );

      await tester.pumpWidget(_wrap(goalsCubit: goals, catsCubit: cats));
      await tester.pumpAndSettle();

      // Body has 1 starred + 0 unstarred → the everything-else row for Body
      // shows the italic empty hint.
      expect(find.text('no goals added'), findsOneWidget);
    });
  });
}
