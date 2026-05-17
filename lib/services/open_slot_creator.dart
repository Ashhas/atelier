import 'package:atelier/domain/models/goal_category.dart';
import 'package:atelier/domain/repositories/goal_category_repository.dart';
import 'package:atelier/utils/uuid.dart';

/// Orchestrates the creation/removal of the pinned add-slot pocket
/// (rendered as "NEW" in the UI; persisted under [_openName] for new
/// installs, while older installs may still carry the prior "Open" name).
///
/// First-launch invariant: `categories` is empty until the user adds their
/// first pocket. At that moment we create both their pocket AND the
/// add-slot. When they remove their last real pocket, we also remove the
/// add-slot.
class OpenSlotCreator {
  OpenSlotCreator(this._categories);

  final GoalCategoryRepository _categories;

  static const String _openName = 'New';

  /// Creates the user's first pocket plus the Open add-slot. Idempotent in the
  /// sense that calling it on a non-empty store falls back to [addPocket].
  Future<GoalCategory> addFirstPocket({required String name}) async {
    final existing = await _categories.all();
    if (existing.isNotEmpty) return addPocket(name: name);

    final pocket = GoalCategory(id: newId(), name: name, order: 0);
    final open = GoalCategory(
      id: newId(),
      name: _openName,
      order: 1,
      isAddSlot: true,
    );
    await _categories.add(pocket);
    await _categories.add(open);
    return pocket;
  }

  /// Adds a new real pocket. Inserts before the Open slot, preserving its
  /// position at the end of the order. If no Open slot exists (corner case
  /// after an external clear), this delegates to [addFirstPocket].
  Future<GoalCategory> addPocket({required String name}) async {
    final all = await _categories.all();
    final hasOpen = all.any((c) => c.isAddSlot);
    if (!hasOpen) return addFirstPocket(name: name);

    final realCount = all.where((c) => !c.isAddSlot).length;
    final pocket = GoalCategory(id: newId(), name: name, order: realCount);
    await _categories.add(pocket);

    // Bump the Open slot to be last.
    final open = all.firstWhere((c) => c.isAddSlot);
    await _categories.update(open.copyWith(order: realCount + 1));
    return pocket;
  }

  /// Removes a real pocket. If it was the last real pocket, also removes the
  /// Open slot so the home screen returns to the blank-slate empty state.
  Future<void> removePocket(String id) async {
    await _categories.delete(id);
    final remaining = await _categories.all();
    final realRemaining = remaining.where((c) => !c.isAddSlot).toList();
    if (realRemaining.isEmpty) {
      // Remove the orphaned Open slot.
      for (final addSlot in remaining.where((c) => c.isAddSlot)) {
        await _categories.delete(addSlot.id);
      }
    } else {
      // Recompact orders so real pockets are 0..N-1 and Open is N.
      final ordered = [
        ...realRemaining,
        ...remaining.where((c) => c.isAddSlot),
      ];
      await _categories.reorder(ordered.map((c) => c.id).toList());
    }
  }
}
