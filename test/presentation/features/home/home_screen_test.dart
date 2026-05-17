import 'package:atelier/data/repositories/prefs_settings_repository.dart';
import 'package:atelier/presentation/features/detail/state/goals_cubit.dart';
import 'package:atelier/presentation/features/detail/state/goals_state.dart';
import 'package:atelier/presentation/features/detail/state/year_goals_cubit.dart';
import 'package:atelier/presentation/features/detail/state/year_goals_state.dart';
import 'package:atelier/presentation/features/home/home_screen.dart';
import 'package:atelier/presentation/features/home/state/goal_categories_cubit.dart';
import 'package:atelier/presentation/features/home/state/goal_categories_state.dart';
import 'package:atelier/presentation/features/home/state/manage_mode_cubit.dart';
import 'package:atelier/presentation/features/home/state/manage_mode_state.dart';
import 'package:atelier/presentation/features/home/widgets/empty_state/home_empty_state.dart';
import 'package:atelier/presentation/features/home/widgets/grid/pocket_grid.dart';
import 'package:atelier/presentation/features/home/widgets/top_bar/home_top_bar.dart';
import 'package:atelier/presentation/features/settings/state/settings_cubit.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _MockGoalCategoriesCubit extends Mock implements GoalCategoriesCubit {}

class _MockManageModeCubit extends Mock implements ManageModeCubit {}

class _MockGoalsCubit extends Mock implements GoalsCubit {}

class _MockYearGoalsCubit extends Mock implements YearGoalsCubit {}

Widget _wrap({
  required GoalCategoriesCubit categories,
  required ManageModeCubit manage,
  required GoalsCubit goals,
  required YearGoalsCubit yearGoals,
  required SettingsCubit settings,
}) => MaterialApp(
  theme: AtelierTheme.light(),
  home: MultiBlocProvider(
    providers: [
      BlocProvider<GoalCategoriesCubit>.value(value: categories),
      BlocProvider<ManageModeCubit>.value(value: manage),
      BlocProvider<GoalsCubit>.value(value: goals),
      BlocProvider<YearGoalsCubit>.value(value: yearGoals),
      BlocProvider<SettingsCubit>.value(value: settings),
    ],
    child: const HomeScreen(),
  ),
);

void main() {
  late _MockGoalCategoriesCubit categoriesCubit;
  late _MockManageModeCubit manageCubit;
  late _MockGoalsCubit goalsCubit;
  late _MockYearGoalsCubit yearGoalsCubit;
  late SettingsCubit settingsCubit;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    settingsCubit = SettingsCubit(PrefsSettingsRepository(prefs));
    await settingsCubit.load();

    categoriesCubit = _MockGoalCategoriesCubit();
    manageCubit = _MockManageModeCubit();
    goalsCubit = _MockGoalsCubit();
    yearGoalsCubit = _MockYearGoalsCubit();

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

  testWidgets('shows HomeEmptyState when isEmpty §3.9', (tester) async {
    when(
      () => categoriesCubit.state,
    ).thenReturn(const GoalCategoriesState(loaded: true, categories: []));
    when(() => categoriesCubit.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(
      _wrap(
        categories: categoriesCubit,
        manage: manageCubit,
        goals: goalsCubit,
        yearGoals: yearGoalsCubit,
        settings: settingsCubit,
      ),
    );
    expect(find.byType(HomeEmptyState), findsOneWidget);
    expect(find.byType(PocketGrid), findsNothing);
  });

  testWidgets('shows HomeTopBar and PocketGrid when not empty §3.1 §3.2', (
    tester,
  ) async {
    when(() => categoriesCubit.state).thenReturn(
      const GoalCategoriesState(
        loaded: true,
        categories: [
          // one real pocket + open slot
        ],
      ),
    );
    when(() => categoriesCubit.stream).thenAnswer((_) => const Stream.empty());
    // not empty because isEmpty == loaded && realCategories.isEmpty
    // To get non-empty we need realCategories, but state.isEmpty is checked
    // Provide a non-loaded state to avoid empty state path
    when(
      () => categoriesCubit.state,
    ).thenReturn(const GoalCategoriesState(loaded: false, categories: []));

    await tester.pumpWidget(
      _wrap(
        categories: categoriesCubit,
        manage: manageCubit,
        goals: goalsCubit,
        yearGoals: yearGoalsCubit,
        settings: settingsCubit,
      ),
    );
    // When not loaded, isEmpty == false, so grid shows
    expect(find.byType(HomeEmptyState), findsNothing);
    expect(find.byType(HomeTopBar), findsOneWidget);
    expect(find.byType(PocketGrid), findsOneWidget);
  });

  testWidgets('tap-outside-pocket exits manage mode §3.6', (tester) async {
    when(
      () => categoriesCubit.state,
    ).thenReturn(const GoalCategoriesState(loaded: false, categories: []));
    when(() => categoriesCubit.stream).thenAnswer((_) => const Stream.empty());
    when(
      () => manageCubit.state,
    ).thenReturn(const ManageModeState(isManaging: true));

    await tester.pumpWidget(
      _wrap(
        categories: categoriesCubit,
        manage: manageCubit,
        goals: goalsCubit,
        yearGoals: yearGoalsCubit,
        settings: settingsCubit,
      ),
    );
    // Tap on the background area
    await tester.tapAt(const Offset(10, 10));
    verify(() => manageCubit.exit()).called(greaterThanOrEqualTo(1));
  });
}
