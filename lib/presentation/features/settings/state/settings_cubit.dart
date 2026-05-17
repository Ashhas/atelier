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

  /// `null` = unbounded ("Full"); otherwise 1..5 per the density spec.
  Future<void> setPocketYearLines(int? lines) async {
    final updated = state.settings.copyWith(pocketYearLines: lines);
    await _repo.write(updated);
    emit(state.copyWith(settings: updated));
  }

  /// `null` = all goals; otherwise 1..15 per the density spec.
  Future<void> setPocketGoalsPreviewCount(int? count) async {
    final updated = state.settings.copyWith(pocketGoalsPreviewCount: count);
    await _repo.write(updated);
    emit(state.copyWith(settings: updated));
  }

  /// Latches `hasGoalEver` to true. Idempotent — safe to call from
  /// every add path. No-op when already true.
  Future<void> markGoalEver() async {
    if (state.settings.hasGoalEver) return;
    final updated = state.settings.copyWith(hasGoalEver: true);
    await _repo.write(updated);
    emit(state.copyWith(settings: updated));
  }

  Future<void> reset() async {
    await _repo.clear();
    await load();
  }
}
