import 'package:atelier/data/repositories/prefs_settings_repository.dart';
import 'package:atelier/domain/models/goal.dart';
import 'package:atelier/domain/models/goal_category.dart';
import 'package:atelier/domain/models/year_goal.dart';
import 'package:atelier/presentation/features/detail/state/goals_cubit.dart';
import 'package:atelier/presentation/features/detail/state/goals_state.dart';
import 'package:atelier/presentation/features/detail/state/year_goals_cubit.dart';
import 'package:atelier/presentation/features/detail/state/year_goals_state.dart';
import 'package:atelier/presentation/features/home/state/goal_categories_cubit.dart';
import 'package:atelier/presentation/features/home/state/goal_categories_state.dart';
import 'package:atelier/presentation/features/home/state/manage_mode_cubit.dart';
import 'package:atelier/presentation/features/home/state/manage_mode_state.dart';
import 'package:atelier/presentation/features/home/widgets/grid/pocket_grid.dart';
import 'package:atelier/presentation/features/home/widgets/pocket/pocket.dart';
import 'package:atelier/presentation/features/settings/state/settings_cubit.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _MockGoalCategoriesCubit extends Mock implements GoalCategoriesCubit {}

class _MockManageModeCubit extends Mock implements ManageModeCubit {}

class _MockGoalsCubit extends Mock implements GoalsCubit {}

class _MockYearGoalsCubit extends Mock implements YearGoalsCubit {}

late SettingsCubit _settingsCubit;

Widget _wrap(
  Widget child, {
  required GoalCategoriesCubit categories,
  required ManageModeCubit manage,
  required GoalsCubit goals,
  required YearGoalsCubit yearGoals,
}) => MaterialApp(
  theme: AtelierTheme.light(),
  home: Scaffold(
    body: MultiBlocProvider(
      providers: [
        BlocProvider<GoalCategoriesCubit>.value(value: categories),
        BlocProvider<ManageModeCubit>.value(value: manage),
        BlocProvider<GoalsCubit>.value(value: goals),
        BlocProvider<YearGoalsCubit>.value(value: yearGoals),
        BlocProvider<SettingsCubit>.value(value: _settingsCubit),
      ],
      child: child,
    ),
  ),
);

void main() {
  late _MockGoalCategoriesCubit categoriesCubit;
  late _MockManageModeCubit manageCubit;
  late _MockGoalsCubit goalsCubit;
  late _MockYearGoalsCubit yearGoalsCubit;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    _settingsCubit = SettingsCubit(PrefsSettingsRepository(prefs));
    await _settingsCubit.load();

    categoriesCubit = _MockGoalCategoriesCubit();
    manageCubit = _MockManageModeCubit();
    goalsCubit = _MockGoalsCubit();
    yearGoalsCubit = _MockYearGoalsCubit();

    when(() => categoriesCubit.state).thenReturn(
      const GoalCategoriesState(
        loaded: true,
        categories: [
          GoalCategory(id: 'w', name: 'Work', order: 0),
          GoalCategory(id: 'b', name: 'Body', order: 1),
          GoalCategory(id: 'open', name: 'Open', order: 2, isAddSlot: true),
        ],
      ),
    );
    when(() => categoriesCubit.stream).thenAnswer((_) => const Stream.empty());

    when(
      () => manageCubit.state,
    ).thenReturn(const ManageModeState(isManaging: false));
    when(() => manageCubit.stream).thenAnswer((_) => const Stream.empty());

    when(() => goalsCubit.state).thenReturn(const GoalsState(loaded: true));
    when(() => goalsCubit.stream).thenAnswer((_) => const Stream.empty());

    when(
      () => yearGoalsCubit.state,
    ).thenReturn(const YearGoalsState(loaded: true));
    when(() => yearGoalsCubit.stream).thenAnswer((_) => const Stream.empty());
  });

  testWidgets('PocketGrid renders one Pocket per visible category §3.2', (
    tester,
  ) async {
    // Tall viewport so all 3 pockets fit on screen with the current
    // childAspectRatio. Offscreen tiles are kept alive by the grid but
    // findByType only finds rendered subtrees.
    tester.view.physicalSize = const Size(400, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      _wrap(
        const PocketGrid(),
        categories: categoriesCubit,
        manage: manageCubit,
        goals: goalsCubit,
        yearGoals: yearGoalsCubit,
      ),
    );
    await tester.pump();
    // 2 real + 1 Open add-slot = 3 pockets
    expect(find.byType(Pocket), findsNWidgets(3));
  });

  testWidgets('Open add-slot hidden in manage mode §3.6', (tester) async {
    when(
      () => manageCubit.state,
    ).thenReturn(const ManageModeState(isManaging: true));

    await tester.pumpWidget(
      _wrap(
        const PocketGrid(),
        categories: categoriesCubit,
        manage: manageCubit,
        goals: goalsCubit,
        yearGoals: yearGoalsCubit,
      ),
    );
    await tester.pump();
    // Only 2 pockets (Open is hidden)
    expect(find.byType(Pocket), findsNWidgets(2));
  });

  testWidgets('tapping a real pocket navigates to /pocket/<id>', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);

    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, __) => MultiBlocProvider(
            providers: [
              BlocProvider<GoalCategoriesCubit>.value(value: categoriesCubit),
              BlocProvider<ManageModeCubit>.value(value: manageCubit),
              BlocProvider<GoalsCubit>.value(value: goalsCubit),
              BlocProvider<YearGoalsCubit>.value(value: yearGoalsCubit),
              BlocProvider<SettingsCubit>.value(value: _settingsCubit),
            ],
            child: const Scaffold(body: PocketGrid()),
          ),
        ),
        GoRoute(
          path: '/pocket/:id',
          builder: (_, state) => Scaffold(
            body: Center(child: Text('detail:${state.pathParameters['id']}')),
          ),
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp.router(theme: AtelierTheme.light(), routerConfig: router),
    );
    await tester.pumpAndSettle();

    // Tap the first real pocket ('Work').
    await tester.tap(find.text('WORK'));
    await tester.pumpAndSettle();
    expect(find.text('detail:w'), findsOneWidget);
  });

  testWidgets('tapping the Open add-slot opens an add-pocket bottom sheet', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      _wrap(
        const PocketGrid(),
        categories: categoriesCubit,
        manage: manageCubit,
        goals: goalsCubit,
        yearGoals: yearGoalsCubit,
      ),
    );
    await tester.pumpAndSettle();

    // The add-slot pocket renders the empty-state label "NEW · ADD"
    // (uppercase with bullet). Tap it to open the sheet.
    await tester.tap(find.text('NEW · ADD'));
    await tester.pumpAndSettle();

    // Sheet shows a TextField with the hint and an ADD button.
    expect(find.text('New pocket name…'), findsOneWidget);
    expect(find.widgetWithText(TextButton, 'ADD'), findsOneWidget);
  });

  testWidgets(
    'pocket year-goal count and goals preview reflect the live cubits',
    (tester) async {
      tester.view.physicalSize = const Size(400, 1200);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);

      // Seed Work with 1 month goal and 1 year goal; Body with none.
      when(() => goalsCubit.state).thenReturn(
        GoalsState(
          loaded: true,
          goals: [
            Goal(
              id: 'g1',
              goalCategoryId: 'w',
              title: 'Sub-25 5K',
              addedAt: DateTime.utc(2026, 5, 1),
            ),
          ],
        ),
      );
      when(() => yearGoalsCubit.state).thenReturn(
        const YearGoalsState(
          loaded: true,
          yearGoals: [
            YearGoal(id: 'y1', goalCategoryId: 'w', title: 'Run a marathon'),
          ],
        ),
      );

      await tester.pumpWidget(
        _wrap(
          const PocketGrid(),
          categories: categoriesCubit,
          manage: manageCubit,
          goals: goalsCubit,
          yearGoals: yearGoalsCubit,
        ),
      );
      await tester.pumpAndSettle();

      // Work pocket should render the year-goal title and the month-goal title.
      // Pocket year preview renders the bullet as a sibling widget — the title
      // text on its own.
      expect(find.text('Run a marathon'), findsOneWidget);
      expect(find.text('Sub-25 5K'), findsOneWidget);
    },
  );
}
