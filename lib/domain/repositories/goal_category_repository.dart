import 'package:atelier/domain/models/goal_category.dart';

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
