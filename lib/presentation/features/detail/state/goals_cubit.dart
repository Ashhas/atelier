import 'package:atelier/domain/models/goal.dart';
import 'package:atelier/domain/repositories/goal_repository.dart';
import 'package:atelier/presentation/features/detail/state/goals_state.dart';
import 'package:atelier/presentation/features/settings/state/settings_cubit.dart';
import 'package:atelier/utils/uuid.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GoalsCubit extends Cubit<GoalsState> {
  GoalsCubit(this._repo, {SettingsCubit? settingsCubit})
    : _settingsCubit = settingsCubit,
      super(const GoalsState());

  final GoalRepository _repo;
  final SettingsCubit? _settingsCubit;

  Future<void> load() async {
    final all = await _repo.all();
    emit(GoalsState(goals: all, loaded: true));
  }

  Future<void> add({
    required String goalCategoryId,
    required String title,
  }) async {
    final trimmed = title.trim();
    if (trimmed.isEmpty) return;
    await _repo.add(
      Goal(
        id: newId(),
        goalCategoryId: goalCategoryId,
        title: trimmed,
        addedAt: DateTime.now(),
      ),
    );
    await load();
    // Latch the first-run flag — drives the empty-state theme toggle's
    // one-time visibility. Idempotent and a no-op when already set.
    await _settingsCubit?.markGoalEver();
  }

  Future<void> rename({required String id, required String title}) async {
    final trimmed = title.trim();
    if (trimmed.isEmpty) return;
    final existing = state.goals.firstWhere((g) => g.id == id);
    await _repo.update(existing.copyWith(title: trimmed));
    await load();
  }

  Future<void> toggleStar(String id) async {
    final existing = state.goals.firstWhere((g) => g.id == id);
    await _repo.update(existing.copyWith(starred: !existing.starred));
    await load();
  }

  Future<void> delete(String id) async {
    await _repo.delete(id);
    await load();
  }

  /// Persists a new ordering for goals in [goalCategoryId]. The list is the
  /// full set of goal ids in their desired top-to-bottom order.
  Future<void> reorder({
    required String goalCategoryId,
    required List<String> orderedIds,
  }) async {
    await _repo.reorder(goalCategoryId: goalCategoryId, orderedIds: orderedIds);
    await load();
  }

  Future<void> reload() => load();
}
