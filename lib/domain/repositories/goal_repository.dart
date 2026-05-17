import 'package:atelier/domain/models/goal.dart';

abstract class GoalRepository {
  /// All goals across all categories, sorted by category then sortOrder.
  Future<List<Goal>> all();

  /// Goals for one category, sorted by sortOrder ascending.
  Future<List<Goal>> byCategory(String goalCategoryId);

  Future<Goal> add(Goal goal);
  Future<void> update(Goal goal);
  Future<void> delete(String id);
  Future<void> clear();

  /// Persists a new ordering for the goals in [goalCategoryId]. The list
  /// is the full set of goal ids in their desired order; implementations
  /// rewrite sortOrder to match.
  Future<void> reorder({
    required String goalCategoryId,
    required List<String> orderedIds,
  });
}
