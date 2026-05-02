// Tests for Task 8.6: gear button opens SettingsSheet; reset wires to
// DataResetter + cubit reloads.

import 'package:atelier/data/drift/atelier_database.dart';
import 'package:atelier/data/repositories/drift_goal_category_repository.dart';
import 'package:atelier/data/repositories/drift_goal_repository.dart';
import 'package:atelier/data/repositories/drift_year_goal_repository.dart';
import 'package:atelier/data/repositories/prefs_settings_repository.dart';
import 'package:atelier/presentation/features/detail/state/goals_cubit.dart';
import 'package:atelier/presentation/features/detail/state/year_goals_cubit.dart';
import 'package:atelier/presentation/features/home/home_screen.dart';
import 'package:atelier/presentation/features/home/state/goal_categories_cubit.dart';
import 'package:atelier/presentation/features/home/state/manage_mode_cubit.dart';
import 'package:atelier/presentation/features/settings/settings_sheet.dart';
import 'package:atelier/presentation/features/settings/state/settings_cubit.dart';
import 'package:atelier/services/data_resetter.dart';
import 'package:atelier/services/open_slot_creator.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Full wiring harness with real in-memory Drift DB + mock SharedPrefs.
Future<_Harness> _buildHarness() async {
  final db = AtelierDatabase.withExecutor(NativeDatabase.memory());
  final catsRepo = DriftGoalCategoryRepository(db);
  final goalsRepo = DriftGoalRepository(db);
  final yearGoalsRepo = DriftYearGoalRepository(db);

  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  final settingsRepo = PrefsSettingsRepository(prefs);

  final openSlot = OpenSlotCreator(catsRepo);
  final resetter = DataResetter(
    categories: catsRepo,
    goals: goalsRepo,
    yearGoals: yearGoalsRepo,
    settingsRepository: settingsRepo,
  );

  final catsCubit = GoalCategoriesCubit(catsRepo, openSlot)..load();
  final goalsCubit = GoalsCubit(goalsRepo)..load();
  final yearGoalsCubit = YearGoalsCubit(yearGoalsRepo)..load();
  final settingsCubit = SettingsCubit(settingsRepo)..load();
  final manageCubit = ManageModeCubit();

  return _Harness(
    db: db,
    resetter: resetter,
    catsCubit: catsCubit,
    goalsCubit: goalsCubit,
    yearGoalsCubit: yearGoalsCubit,
    settingsCubit: settingsCubit,
    manageCubit: manageCubit,
  );
}

final class _Harness {
  const _Harness({
    required this.db,
    required this.resetter,
    required this.catsCubit,
    required this.goalsCubit,
    required this.yearGoalsCubit,
    required this.settingsCubit,
    required this.manageCubit,
  });

  final AtelierDatabase db;
  final DataResetter resetter;
  final GoalCategoriesCubit catsCubit;
  final GoalsCubit goalsCubit;
  final YearGoalsCubit yearGoalsCubit;
  final SettingsCubit settingsCubit;
  final ManageModeCubit manageCubit;

  Future<void> dispose() => db.close();
}

Widget _wrapWithHarness(_Harness h) => MaterialApp(
  theme: AtelierTheme.light(),
  home: MultiRepositoryProvider(
    providers: [RepositoryProvider.value(value: h.resetter)],
    child: MultiBlocProvider(
      providers: [
        BlocProvider<GoalCategoriesCubit>.value(value: h.catsCubit),
        BlocProvider<GoalsCubit>.value(value: h.goalsCubit),
        BlocProvider<YearGoalsCubit>.value(value: h.yearGoalsCubit),
        BlocProvider<SettingsCubit>.value(value: h.settingsCubit),
        BlocProvider<ManageModeCubit>.value(value: h.manageCubit),
      ],
      child: const HomeScreen(),
    ),
  ),
);

void main() {
  group('Gear button + SettingsSheet wiring §3.7', () {
    testWidgets('tapping gear button opens SettingsSheet', (tester) async {
      final h = await _buildHarness();
      addTearDown(h.dispose);
      await tester.pumpWidget(_wrapWithHarness(h));
      await tester.pumpAndSettle();

      expect(find.byType(SettingsSheet), findsNothing);
      await tester.tap(find.text('⚙'));
      await tester.pumpAndSettle();
      expect(find.byType(SettingsSheet), findsOneWidget);
    });

    testWidgets('reset: cubits reload to empty state and sheet closes', (
      tester,
    ) async {
      final h = await _buildHarness();
      addTearDown(h.dispose);
      await tester.pumpWidget(_wrapWithHarness(h));
      await tester.pumpAndSettle();

      // Open settings sheet.
      await tester.tap(find.text('⚙'));
      await tester.pumpAndSettle();
      expect(find.byType(SettingsSheet), findsOneWidget);

      // Tap "Reset all data" to show confirm.
      await tester.tap(find.text('Reset all data'));
      await tester.pumpAndSettle();
      expect(find.text('RESET'), findsOneWidget);

      // Confirm reset.
      await tester.tap(find.text('RESET'));
      await tester.pumpAndSettle();

      // Sheet should be closed.
      expect(find.byType(SettingsSheet), findsNothing);
      // Cubits should have reloaded with empty state.
      expect(h.catsCubit.state.categories, isEmpty);
      expect(h.goalsCubit.state.goals, isEmpty);
      expect(h.yearGoalsCubit.state.yearGoals, isEmpty);
    });
  });
}
