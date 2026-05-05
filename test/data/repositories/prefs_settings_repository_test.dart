import 'package:atelier/data/repositories/prefs_settings_repository.dart';
import 'package:atelier/domain/models/app_settings.dart';
import 'package:atelier/domain/models/enums/font_scale.dart';
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
    await repo.write(
      const AppSettings(themeMode: ThemeMode.dark, fontScale: FontScale.large),
    );
    expect(
      await repo.read(),
      const AppSettings(themeMode: ThemeMode.dark, fontScale: FontScale.large),
    );
  });

  test('clear restores defaults', () async {
    final prefs = await SharedPreferences.getInstance();
    final repo = PrefsSettingsRepository(prefs);
    await repo.write(const AppSettings(themeMode: ThemeMode.dark));
    await repo.clear();
    expect(await repo.read(), const AppSettings());
  });
}
