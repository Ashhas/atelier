import 'package:atelier/data/repositories/prefs_settings_repository.dart';
import 'package:atelier/domain/models/app_settings.dart';
import 'package:atelier/domain/models/enums/font_scale.dart';
import 'package:atelier/presentation/features/settings/state/settings_cubit.dart';
import 'package:atelier/presentation/features/settings/state/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late PrefsSettingsRepository repo;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    repo = PrefsSettingsRepository(prefs);
  });

  test('load emits defaults on a fresh store', () async {
    final cubit = SettingsCubit(repo);
    final emitted = <SettingsState>[];
    final sub = cubit.stream.listen(emitted.add);
    await cubit.load();
    await Future<void>.delayed(Duration.zero);
    await sub.cancel();
    expect(emitted, hasLength(1));
    expect(emitted.last.settings, const AppSettings());
    expect(emitted.last.loaded, isTrue);
  });

  test('setTheme persists + emits', () async {
    final cubit = SettingsCubit(repo);
    final emitted = <SettingsState>[];
    final sub = cubit.stream.listen(emitted.add);
    await cubit.load();
    await cubit.setTheme(ThemeMode.dark);
    await Future<void>.delayed(Duration.zero);
    await sub.cancel();
    final afterSetTheme = emitted.skip(1).toList();
    expect(afterSetTheme, hasLength(1));
    expect(afterSetTheme.last.settings.themeMode, ThemeMode.dark);
  });

  test('setFontScale persists + emits', () async {
    final cubit = SettingsCubit(repo);
    final emitted = <SettingsState>[];
    final sub = cubit.stream.listen(emitted.add);
    await cubit.load();
    await cubit.setFontScale(FontScale.large);
    await Future<void>.delayed(Duration.zero);
    await sub.cancel();
    final afterSetScale = emitted.skip(1).toList();
    expect(afterSetScale, hasLength(1));
    expect(afterSetScale.last.settings.fontScale, FontScale.large);
  });

  test('setPocketYearLines accepts both ints and null (Full)', () async {
    final cubit = SettingsCubit(repo);
    await cubit.load();

    await cubit.setPocketYearLines(4);
    expect(cubit.state.settings.pocketYearLines, 4);

    await cubit.setPocketYearLines(null);
    expect(cubit.state.settings.pocketYearLines, isNull);
  });

  test('setPocketGoalsPreviewCount accepts both ints and null (All)', () async {
    final cubit = SettingsCubit(repo);
    await cubit.load();

    await cubit.setPocketGoalsPreviewCount(7);
    expect(cubit.state.settings.pocketGoalsPreviewCount, 7);

    await cubit.setPocketGoalsPreviewCount(null);
    expect(cubit.state.settings.pocketGoalsPreviewCount, isNull);
  });
}
