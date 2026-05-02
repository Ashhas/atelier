import 'package:atelier/domain/models/goal_category.dart';

/// Persistence contract for [GoalCategory] (a "pocket" in the UI).
///
/// **Invariant for `isAddSlot == true` rows ("Open" pocket):**
/// the Open slot must always be the last row by `order`, and there must be
/// at most one Open slot at any time. This invariant is owned by
/// `OpenSlotCreator` and enforced through it. Direct calls to [add],
/// [update], [delete], or [reorder] from anywhere else must NOT mutate
/// `isAddSlot` rows or insert new ones — go through `OpenSlotCreator`
/// instead. The contract trusts callers; v1 has no runtime enforcement.
abstract class GoalCategoryRepository {
  /// All categories ordered by [GoalCategory.order] ascending.
  Future<List<GoalCategory>> all();

  /// Inserts the category. Returns the inserted row.
  Future<GoalCategory> add(GoalCategory category);

  Future<void> update(GoalCategory category);

  /// Deletes the category and cascades to its goals + year-goals.
  Future<void> delete(String id);

  /// Persists a new ordering (bulk update).
  Future<void> reorder(List<String> idsInNewOrder);

  /// Truncates the table.
  Future<void> clear();
}
