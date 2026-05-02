import 'package:atelier/domain/models/enums/font_scale.dart';
import 'package:atelier/domain/repositories/settings_repository.dart';
import 'package:atelier/presentation/features/settings/state/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this._repo) : super(const SettingsState());

  final SettingsRepository _repo;

  Future<void> load() async {
    final settings = await _repo.read();
    emit(SettingsState(settings: settings, loaded: true));
  }

  Future<void> setTheme(ThemeMode mode) async {
    final updated = state.settings.copyWith(themeMode: mode);
    await _repo.write(updated);
    emit(state.copyWith(settings: updated));
  }

  Future<void> setFontScale(FontScale scale) async {
    final updated = state.settings.copyWith(fontScale: scale);
    await _repo.write(updated);
    emit(state.copyWith(settings: updated));
  }

  Future<void> reset() async {
    await _repo.clear();
    await load();
  }
}
