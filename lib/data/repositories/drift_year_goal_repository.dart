import 'package:atelier/data/drift/atelier_database.dart';
import 'package:atelier/domain/models/year_goal.dart';
import 'package:atelier/domain/repositories/year_goal_repository.dart';
import 'package:drift/drift.dart';

class DriftYearGoalRepository implements YearGoalRepository {
  DriftYearGoalRepository(this._db);

  final AtelierDatabase _db;

  @override
  Future<List<YearGoal>> all() async {
    final rows = await _db.select(_db.yearGoalsTable).get();
    return rows.map(_fromRow).toList(growable: false);
  }

  @override
  Future<List<YearGoal>> byCategory(String goalCategoryId) async {
    final query = _db.select(_db.yearGoalsTable)
      ..where((t) => t.goalCategoryId.equals(goalCategoryId));
    final rows = await query.get();
    return rows.map(_fromRow).toList(growable: false);
  }

  @override
  Future<YearGoal> add(YearGoal yg) async {
    await _db.into(_db.yearGoalsTable).insert(_toCompanion(yg));
    return yg;
  }

  @override
  Future<void> update(YearGoal yg) async {
    await (_db.update(
      _db.yearGoalsTable,
    )..where((t) => t.id.equals(yg.id))).write(_toCompanion(yg));
  }

  @override
  Future<void> delete(String id) async {
    await (_db.delete(_db.yearGoalsTable)..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<void> clear() async {
    await _db.delete(_db.yearGoalsTable).go();
  }

  YearGoal _fromRow(YearGoalRow r) => YearGoal(
    id: r.id,
    goalCategoryId: r.goalCategoryId,
    title: r.title,
    expanded: r.expanded,
  );

  YearGoalsTableCompanion _toCompanion(YearGoal y) => YearGoalsTableCompanion(
    id: Value(y.id),
    goalCategoryId: Value(y.goalCategoryId),
    title: Value(y.title),
    expanded: Value(y.expanded),
  );
}
