import 'package:atelier/domain/models/year_goal.dart';
import 'package:atelier/domain/repositories/year_goal_repository.dart';
import 'package:atelier/presentation/features/detail/state/year_goals_state.dart';
import 'package:atelier/utils/uuid.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class YearGoalsCubit extends Cubit<YearGoalsState> {
  YearGoalsCubit(this._repo) : super(const YearGoalsState());

  final YearGoalRepository _repo;

  Future<void> load() async {
    final all = await _repo.all();
    emit(YearGoalsState(yearGoals: all, loaded: true));
  }

  Future<void> add({required String goalCategoryId, required String title}) async {
    final trimmed = title.trim();
    if (trimmed.isEmpty) return;
    await _repo.add(
      YearGoal(id: newId(), goalCategoryId: goalCategoryId, title: trimmed),
    );
    await load();
  }

  Future<void> rename({required String id, required String title}) async {
    final trimmed = title.trim();
    if (trimmed.isEmpty) return;
    final existing = state.yearGoals.firstWhere((g) => g.id == id);
    await _repo.update(existing.copyWith(title: trimmed));
    await load();
  }

  Future<void> toggleExpanded(String id) async {
    final existing = state.yearGoals.firstWhere((g) => g.id == id);
    await _repo.update(existing.copyWith(expanded: !existing.expanded));
    await load();
  }

  Future<void> delete(String id) async {
    await _repo.delete(id);
    await load();
  }

  Future<void> reload() => load();
}
