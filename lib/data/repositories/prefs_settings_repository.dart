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

  @override
  Future<AppSettings> read() async {
    final theme = _prefs.getString(_kThemeMode);
    final scale = _prefs.getString(_kFontScale);
    return AppSettings(
      themeMode: _parseTheme(theme),
      fontScale: _parseScale(scale),
    );
  }

  @override
  Future<void> write(AppSettings settings) async {
    await _prefs.setString(_kThemeMode, settings.themeMode.name);
    await _prefs.setString(_kFontScale, settings.fontScale.name);
  }

  @override
  Future<void> clear() async {
    await _prefs.remove(_kThemeMode);
    await _prefs.remove(_kFontScale);
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
}
