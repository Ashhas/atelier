import 'package:atelier/domain/models/goal.dart';

abstract class GoalRepository {
  /// All goals across all categories, sorted starred-first then insertion order.
  Future<List<Goal>> all();

  /// Goals for one category, sorted starred-first then insertion order.
  Future<List<Goal>> byCategory(String goalCategoryId);

  Future<Goal> add(Goal goal);
  Future<void> update(Goal goal);
  Future<void> delete(String id);
  Future<void> clear();
}
