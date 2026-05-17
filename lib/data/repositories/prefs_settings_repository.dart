import 'package:atelier/domain/models/app_settings.dart';
import 'package:atelier/domain/models/enums/font_scale.dart';
import 'package:atelier/domain/repositories/settings_repository.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsSettingsRepository implements SettingsRepository {
  PrefsSettingsRepository(this._prefs);

  final SharedPreferences _prefs;

  static const _kThemeMode = 'atelier.themeMode';
  static const _kFontScale = 'atelier.fontScale';
  static const _kPocketYearLines = 'atelier.pocketYearLines';
  static const _kPocketGoalsPreviewCount = 'atelier.pocketGoalsPreviewCount';
  static const _kHasGoalEver = 'atelier.hasGoalEver';

  // String tokens for the unbounded values; integers otherwise.
  static const _kUnboundedLines = 'full';
  static const _kUnboundedCount = 'all';

  @override
  Future<AppSettings> read() async {
    return AppSettings(
      themeMode: _parseTheme(_prefs.getString(_kThemeMode)),
      fontScale: _parseScale(_prefs.getString(_kFontScale)),
      pocketYearLines: _parseNullableInt(
        _prefs.getString(_kPocketYearLines),
        unboundedToken: _kUnboundedLines,
        defaultValue: 1,
      ),
      pocketGoalsPreviewCount: _parseNullableInt(
        _prefs.getString(_kPocketGoalsPreviewCount),
        unboundedToken: _kUnboundedCount,
        defaultValue: 3,
      ),
      hasGoalEver: _prefs.getBool(_kHasGoalEver) ?? false,
    );
  }

  @override
  Future<void> write(AppSettings settings) async {
    await _prefs.setString(_kThemeMode, settings.themeMode.name);
    await _prefs.setString(_kFontScale, settings.fontScale.name);
    await _prefs.setString(
      _kPocketYearLines,
      _encodeNullableInt(settings.pocketYearLines, _kUnboundedLines),
    );
    await _prefs.setString(
      _kPocketGoalsPreviewCount,
      _encodeNullableInt(settings.pocketGoalsPreviewCount, _kUnboundedCount),
    );
    await _prefs.setBool(_kHasGoalEver, settings.hasGoalEver);
  }

  @override
  Future<void> clear() async {
    await _prefs.remove(_kThemeMode);
    await _prefs.remove(_kFontScale);
    await _prefs.remove(_kPocketYearLines);
    await _prefs.remove(_kPocketGoalsPreviewCount);
    await _prefs.remove(_kHasGoalEver);
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

  int? _parseNullableInt(
    String? raw, {
    required String unboundedToken,
    required int defaultValue,
  }) {
    if (raw == null) return defaultValue;
    if (raw == unboundedToken) return null;
    return int.tryParse(raw) ?? defaultValue;
  }

  String _encodeNullableInt(int? value, String unboundedToken) =>
      value == null ? unboundedToken : value.toString();
}
