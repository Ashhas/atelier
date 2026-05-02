import 'package:atelier/domain/repositories/goal_category_repository.dart';
import 'package:atelier/presentation/features/home/state/goal_categories_state.dart';
import 'package:atelier/services/open_slot_creator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GoalCategoriesCubit extends Cubit<GoalCategoriesState> {
  GoalCategoriesCubit(this._repo, this._openSlot)
    : super(const GoalCategoriesState());

  final GoalCategoryRepository _repo;
  final OpenSlotCreator _openSlot;

  Future<void> load() async {
    final all = await _repo.all();
    emit(GoalCategoriesState(categories: all, loaded: true));
  }

  Future<void> addPocket(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    if (state.realCategories.isEmpty) {
      await _openSlot.addFirstPocket(name: trimmed);
    } else {
      await _openSlot.addPocket(name: trimmed);
    }
    await load();
  }

  Future<void> renamePocket(String id, String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    final existing = state.categories.firstWhere((c) => c.id == id);
    await _repo.update(existing.copyWith(name: trimmed));
    await load();
  }

  Future<void> removePocket(String id) async {
    await _openSlot.removePocket(id);
    await load();
  }

  Future<void> reorder(List<String> realIdsInNewOrder) async {
    final openSlot = state.categories
        .where((c) => c.isAddSlot)
        .map((c) => c.id);
    await _repo.reorder([...realIdsInNewOrder, ...openSlot]);
    await load();
  }

  Future<void> reload() => load();
}
