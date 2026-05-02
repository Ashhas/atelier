import 'package:atelier/data/drift/atelier_database.dart';
import 'package:atelier/data/repositories/drift_goal_category_repository.dart';
import 'package:atelier/data/repositories/drift_goal_repository.dart';
import 'package:atelier/data/repositories/drift_year_goal_repository.dart';
import 'package:atelier/data/repositories/prefs_settings_repository.dart';
import 'package:atelier/domain/models/app_settings.dart';
import 'package:atelier/domain/models/enums/font_scale.dart';
import 'package:atelier/domain/models/goal_category.dart';
import 'package:atelier/services/data_resetter.dart';
import 'package:atelier/services/open_slot_creator.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('reset() wipes categories, goals, year-goals and settings', () async {
    // --- Arrange ---
    final db = AtelierDatabase.withExecutor(NativeDatabase.memory());
    final cats = DriftGoalCategoryRepository(db);
    final goals = DriftGoalRepository(db);
    final yearGoals = DriftYearGoalRepository(db);

    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final settings = PrefsSettingsRepository(prefs);

    // Seed some data.
    final creator = OpenSlotCreator(cats);
    await creator.addFirstPocket(name: 'Work');
    // Confirm data exists.
    expect(await cats.all(), isNotEmpty);

    // Change settings away from defaults.
    await settings.write(
      const AppSettings(themeMode: ThemeMode.dark, fontScale: FontScale.large),
    );

    // --- Act ---
    final resetter = DataResetter(
      categories: cats,
      goals: goals,
      yearGoals: yearGoals,
      settingsRepository: settings,
    );
    await resetter.reset();

    // --- Assert ---
    expect(await cats.all(), isEmpty);
    expect(await goals.all(), isEmpty);
    expect(await yearGoals.all(), isEmpty);
    expect(await settings.read(), const AppSettings());

    await db.close();
  });
}
