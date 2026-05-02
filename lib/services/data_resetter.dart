import 'package:atelier/domain/repositories/goal_category_repository.dart';
import 'package:atelier/domain/repositories/goal_repository.dart';
import 'package:atelier/domain/repositories/settings_repository.dart';
import 'package:atelier/domain/repositories/year_goal_repository.dart';

/// Wipes all user data and resets settings to factory defaults.
///
/// Called from the Settings → Reset flow. After [reset] completes the app
/// should navigate back to the home screen (which will show the empty state).
class DataResetter {
  DataResetter({
    required this.categories,
    required this.goals,
    required this.yearGoals,
    required this.settingsRepository,
  });

  final GoalCategoryRepository categories;
  final GoalRepository goals;
  final YearGoalRepository yearGoals;
  final SettingsRepository settingsRepository;

  /// Truncates every store and resets settings to defaults.
  Future<void> reset() async {
    // Clear goals and year-goals before categories to avoid FK issues.
    await goals.clear();
    await yearGoals.clear();
    await categories.clear();
    await settingsRepository.clear();
  }
}
