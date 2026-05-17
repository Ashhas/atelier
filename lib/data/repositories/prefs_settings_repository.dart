import 'package:atelier/domain/models/app_settings.dart';
import 'package:atelier/domain/models/enums/font_scale.dart';
import 'package:atelier/domain/models/enums/pocket_goals_preview_count.dart';
import 'package:atelier/domain/models/enums/pocket_year_line_mode.dart';
import 'package:atelier/domain/repositories/settings_repository.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsSettingsRepository implements SettingsRepository {
  PrefsSettingsRepository(this._prefs);

  final SharedPreferences _prefs;

  static const _kThemeMode = 'atelier.themeMode';
  static const _kFontScale = 'atelier.fontScale';
  static const _kPocketYearLineMode = 'atelier.pocketYearLineMode';
  static const _kPocketGoalsPreviewCount = 'atelier.pocketGoalsPreviewCount';

  @override
  Future<AppSettings> read() async {
    final theme = _prefs.getString(_kThemeMode);
    final scale = _prefs.getString(_kFontScale);
    final lineMode = _prefs.getString(_kPocketYearLineMode);
    final goalsCount = _prefs.getString(_kPocketGoalsPreviewCount);
    return AppSettings(
      themeMode: _parseTheme(theme),
      fontScale: _parseScale(scale),
      pocketYearLineMode: _parseLineMode(lineMode),
      pocketGoalsPreviewCount: _parseGoalsCount(goalsCount),
    );
  }

  @override
  Future<void> write(AppSettings settings) async {
    await _prefs.setString(_kThemeMode, settings.themeMode.name);
    await _prefs.setString(_kFontScale, settings.fontScale.name);
    await _prefs.setString(
      _kPocketYearLineMode,
      settings.pocketYearLineMode.name,
    );
    await _prefs.setString(
      _kPocketGoalsPreviewCount,
      settings.pocketGoalsPreviewCount.name,
    );
  }

  @override
  Future<void> clear() async {
    await _prefs.remove(_kThemeMode);
    await _prefs.remove(_kFontScale);
    await _prefs.remove(_kPocketYearLineMode);
    await _prefs.remove(_kPocketGoalsPreviewCount);
  }

  ThemeMode _parseTheme(String? raw) {
    switch (raw) {
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.light;
    }
  }

  FontScale _parseScale(String? raw) {
    switch (raw) {
      case 'small':
        return FontScale.small;
      case 'large':
        return FontScale.large;
      default:
        return FontScale.medium;
    }
  }

  PocketYearLineMode _parseLineMode(String? raw) {
    switch (raw) {
      case 'twoLines':
        return PocketYearLineMode.twoLines;
      case 'full':
        return PocketYearLineMode.full;
      default:
        return PocketYearLineMode.oneLine;
    }
  }

  PocketGoalsPreviewCount _parseGoalsCount(String? raw) {
    switch (raw) {
      case 'five':
        return PocketGoalsPreviewCount.five;
      case 'all':
        return PocketGoalsPreviewCount.all;
      default:
        return PocketGoalsPreviewCount.three;
    }
  }
}
