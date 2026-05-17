import 'package:atelier/data/repositories/prefs_settings_repository.dart';
import 'package:atelier/domain/models/app_settings.dart';
import 'package:atelier/domain/models/enums/font_scale.dart';
import 'package:atelier/domain/models/enums/pocket_goals_preview_count.dart';
import 'package:atelier/domain/models/enums/pocket_year_line_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('read on empty store returns defaults', () async {
    final prefs = await SharedPreferences.getInstance();
    final repo = PrefsSettingsRepository(prefs);
    expect(await repo.read(), const AppSettings());
  });

  test('write then read round-trips', () async {
    final prefs = await SharedPreferences.getInstance();
    final repo = PrefsSettingsRepository(prefs);
    const settings = AppSettings(
      themeMode: ThemeMode.dark,
      fontScale: FontScale.large,
      pocketYearLineMode: PocketYearLineMode.full,
      pocketGoalsPreviewCount: PocketGoalsPreviewCount.all,
    );
    await repo.write(settings);
    expect(await repo.read(), settings);
  });

  test('clear restores defaults', () async {
    final prefs = await SharedPreferences.getInstance();
    final repo = PrefsSettingsRepository(prefs);
    await repo.write(
      const AppSettings(
        themeMode: ThemeMode.dark,
        pocketYearLineMode: PocketYearLineMode.twoLines,
      ),
    );
    await repo.clear();
    expect(await repo.read(), const AppSettings());
  });
}
