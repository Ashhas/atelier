import 'package:atelier/domain/models/year_goal.dart';

abstract class YearGoalRepository {
  Future<List<YearGoal>> all();
  Future<List<YearGoal>> byCategory(String goalCategoryId);
  Future<YearGoal> add(YearGoal yg);
  Future<void> update(YearGoal yg);
  Future<void> delete(String id);
  Future<void> clear();
}
