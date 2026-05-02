import 'package:atelier/presentation/features/detail/state/goals_cubit.dart';
import 'package:atelier/presentation/features/detail/state/year_goals_cubit.dart';
import 'package:atelier/presentation/features/home/state/goal_categories_cubit.dart';
import 'package:atelier/presentation/features/home/state/goal_categories_state.dart';
import 'package:atelier/presentation/features/home/state/manage_mode_cubit.dart';
import 'package:atelier/presentation/features/home/state/manage_mode_state.dart';
import 'package:atelier/presentation/features/home/widgets/empty_state/home_empty_state.dart';
import 'package:atelier/presentation/features/home/widgets/grid/pocket_grid.dart';
import 'package:atelier/presentation/features/home/widgets/top_bar/home_top_bar.dart';
import 'package:atelier/presentation/features/settings/settings_sheet.dart';
import 'package:atelier/presentation/features/settings/state/settings_cubit.dart';
import 'package:atelier/services/data_resetter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Main home screen: top bar + tick strip + pocket grid, OR empty state.
///
/// Chrome (HomeTopBar with TickStrip) is always visible (spec §3.9).
/// Tap outside any pocket while in manage mode exits manage mode (spec §3.6).
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GoalCategoriesCubit, GoalCategoriesState>(
      builder: (context, catState) {
        return BlocBuilder<ManageModeCubit, ManageModeState>(
          builder: (context, manageState) {
            final isManaging = manageState.isManaging;
            final isEmpty = catState.isEmpty;
            final manageCubit = context.read<ManageModeCubit>();
            final now = DateTime.now();

            final body = Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                HomeTopBar(
                  now: now,
                  isManaging: isManaging,
                  onSettings: () => _openSettings(context),
                  onDone: manageCubit.exit,
                ),
                Expanded(
                  child: isEmpty
                      ? const SingleChildScrollView(child: HomeEmptyState())
                      // PocketGrid (MasonryGridView) scrolls itself — wrapping
                      // it in another scroll view would defeat lazy layout.
                      : const PocketGrid(),
                ),
              ],
            );

            return Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              body: SafeArea(
                child: isManaging
                    ? GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: manageCubit.exit,
                        child: body,
                      )
                    : body,
              ),
            );
          },
        );
      },
    );
  }

  void _openSettings(BuildContext context) {
    // Capture cubits/repositories before the modal's new BuildContext is
    // created, so they remain accessible inside the sheet.
    final settingsCubit = context.read<SettingsCubit>();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider<SettingsCubit>.value(
        value: settingsCubit,
        child: SettingsSheet(onReset: () => _handleReset(context)),
      ),
    );
  }

  Future<void> _handleReset(BuildContext context) async {
    // Capture everything synchronously before any await.
    final resetter = context.read<DataResetter>();
    final catsCubit = context.read<GoalCategoriesCubit>();
    final goalsCubit = context.read<GoalsCubit>();
    final yearGoalsCubit = context.read<YearGoalsCubit>();
    final settingsCubit = context.read<SettingsCubit>();
    final navigator = Navigator.of(context);

    // 1. Wipe all data stores.
    await resetter.reset();
    // 2. Reload cubits from the now-empty stores.
    await catsCubit.reload();
    await goalsCubit.reload();
    await yearGoalsCubit.reload();
    // SettingsCubit.reset() clears prefs and re-emits defaults.
    await settingsCubit.reset();
    // 3. Close the sheet — but only if the user hasn't already left.
    if (!context.mounted) return;
    navigator.pop();
  }
}
