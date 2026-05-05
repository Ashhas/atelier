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
import 'package:atelier/services/export_service.dart';
import 'package:atelier/services/open_slot_creator.dart';
import 'package:atelier/theme/atelier_colors.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// App-wide scroll behavior that suppresses the Android Material overscroll
/// glow + the iOS bouncing edge. The minimal Atelier visual language doesn't
/// fit either — overscroll content briefly tints the scaffold colour green
/// on Android because the indicator inherits the colorScheme accent.
class _NoOverscrollBehavior extends MaterialScrollBehavior {
  const _NoOverscrollBehavior();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) => child;
}

class AtelierApp extends StatefulWidget {
  const AtelierApp({super.key, required this.database, required this.prefs});

  final AtelierDatabase database;
  final SharedPreferences prefs;

  @override
  State<AtelierApp> createState() => _AtelierAppState();
}

class _AtelierAppState extends State<AtelierApp> {
  late final DriftGoalCategoryRepository _categoriesRepo;
  late final DriftGoalRepository _goalsRepo;
  late final DriftYearGoalRepository _yearGoalsRepo;
  late final PrefsSettingsRepository _settingsRepo;
  late final OpenSlotCreator _openSlot;
  late final DataResetter _resetter;
  late final ExportService _exporter;
  late final GoRouter _router;

  /// Resolves the effective brightness for the system UI overlay, accounting
  /// for ThemeMode.system using the platform's reported brightness.
  bool _resolveIsDark(BuildContext context, ThemeMode mode) {
    switch (mode) {
      case ThemeMode.dark:
        return true;
      case ThemeMode.light:
        return false;
      case ThemeMode.system:
        return MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    }
  }

  @override
  void initState() {
    super.initState();
    _categoriesRepo = DriftGoalCategoryRepository(widget.database);
    _goalsRepo = DriftGoalRepository(widget.database);
    _yearGoalsRepo = DriftYearGoalRepository(widget.database);
    _settingsRepo = PrefsSettingsRepository(widget.prefs);
    _openSlot = OpenSlotCreator(_categoriesRepo);
    _resetter = DataResetter(
      categories: _categoriesRepo,
      goals: _goalsRepo,
      yearGoals: _yearGoalsRepo,
      settingsRepository: _settingsRepo,
    );
    _exporter = ExportService(
      categories: _categoriesRepo,
      goals: _goalsRepo,
      yearGoals: _yearGoalsRepo,
      settingsRepository: _settingsRepo,
    );
    _router = AtelierRouter.build();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _resetter),
        RepositoryProvider.value(value: _exporter),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) =>
                GoalCategoriesCubit(_categoriesRepo, _openSlot)..load(),
          ),
          BlocProvider(create: (_) => GoalsCubit(_goalsRepo)..load()),
          BlocProvider(create: (_) => YearGoalsCubit(_yearGoalsRepo)..load()),
          BlocProvider(create: (_) => SettingsCubit(_settingsRepo)..load()),
          BlocProvider(create: (_) => ManageModeCubit()),
        ],
        child: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            final scale = state.settings.fontScale.multiplier;
            final isDark = _resolveIsDark(context, state.settings.themeMode);
            final palette = isDark ? AtelierColors.dark : AtelierColors.light;
            // Edge-to-edge bars: transparent overlay so the scaffold colour
            // shows through on both the status bar and the system nav bar.
            // Icon brightness is the inverse of the surface brightness so
            // the system icons stay legible.
            final overlayStyle = SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: isDark
                  ? Brightness.light
                  : Brightness.dark,
              statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
              systemNavigationBarColor: palette.bg,
              systemNavigationBarIconBrightness: isDark
                  ? Brightness.light
                  : Brightness.dark,
              systemNavigationBarDividerColor: palette.bg,
            );
            return AnnotatedRegion<SystemUiOverlayStyle>(
              value: overlayStyle,
              child: MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: TextScaler.linear(scale)),
                child: MaterialApp.router(
                  title: 'Atelier',
                  theme: AtelierTheme.light(),
                  darkTheme: AtelierTheme.dark(),
                  themeMode: state.settings.themeMode,
                  routerConfig: _router,
                  scrollBehavior: const _NoOverscrollBehavior(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
