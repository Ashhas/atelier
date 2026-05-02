import 'package:atelier/config/router.dart';
import 'package:atelier/data/drift/atelier_database.dart';
import 'package:atelier/data/repositories/drift_goal_category_repository.dart';
import 'package:atelier/data/repositories/drift_goal_repository.dart';
import 'package:atelier/data/repositories/drift_year_goal_repository.dart';
import 'package:atelier/data/repositories/prefs_settings_repository.dart';
import 'package:atelier/presentation/features/detail/state/goals_cubit.dart';
import 'package:atelier/presentation/features/detail/state/year_goals_cubit.dart';
import 'package:atelier/presentation/features/home/state/goal_categories_cubit.dart';
import 'package:atelier/presentation/features/home/state/manage_mode_cubit.dart';
import 'package:atelier/presentation/features/settings/state/settings_cubit.dart';
import 'package:atelier/presentation/features/settings/state/settings_state.dart';
import 'package:atelier/services/data_resetter.dart';
import 'package:atelier/services/open_slot_creator.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AtelierApp extends StatelessWidget {
  const AtelierApp({super.key, required this.database, required this.prefs});

  final AtelierDatabase database;
  final SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {
    final categoriesRepo = DriftGoalCategoryRepository(database);
    final goalsRepo = DriftGoalRepository(database);
    final yearGoalsRepo = DriftYearGoalRepository(database);
    final settingsRepo = PrefsSettingsRepository(prefs);
    final openSlot = OpenSlotCreator(categoriesRepo);
    final resetter = DataResetter(
      categories: categoriesRepo,
      goals: goalsRepo,
      yearGoals: yearGoalsRepo,
      settingsRepository: settingsRepo,
    );

    return MultiRepositoryProvider(
      providers: [RepositoryProvider.value(value: resetter)],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) =>
                GoalCategoriesCubit(categoriesRepo, openSlot)..load(),
          ),
          BlocProvider(create: (_) => GoalsCubit(goalsRepo)..load()),
          BlocProvider(create: (_) => YearGoalsCubit(yearGoalsRepo)..load()),
          BlocProvider(create: (_) => SettingsCubit(settingsRepo)..load()),
          BlocProvider(create: (_) => ManageModeCubit()),
        ],
        child: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            final scale = state.settings.fontScale.multiplier;
            return MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: TextScaler.linear(scale)),
              child: MaterialApp.router(
                title: 'Atelier',
                theme: AtelierTheme.light(),
                darkTheme: AtelierTheme.dark(),
                themeMode: state.settings.themeMode,
                routerConfig: AtelierRouter.build(),
              ),
            );
          },
        ),
      ),
    );
  }
}
