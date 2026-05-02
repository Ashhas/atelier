import 'package:atelier/data/drift/atelier_database.dart';
import 'package:atelier/domain/models/goal.dart';
import 'package:atelier/domain/repositories/goal_repository.dart';
import 'package:drift/drift.dart';

class DriftGoalRepository implements GoalRepository {
  DriftGoalRepository(this._db);

  final AtelierDatabase _db;

  @override
  Future<List<Goal>> all() async {
    final query = _db.select(_db.goalsTable)
      ..orderBy([
        (t) => OrderingTerm.desc(t.starred),
        (t) => OrderingTerm.asc(t.addedAt),
      ]);
    final rows = await query.get();
    return rows.map(_fromRow).toList(growable: false);
  }

  @override
  Future<List<Goal>> byCategory(String goalCategoryId) async {
    final query = _db.select(_db.goalsTable)
      ..where((t) => t.goalCategoryId.equals(goalCategoryId))
      ..orderBy([
        (t) => OrderingTerm.desc(t.starred),
        (t) => OrderingTerm.asc(t.addedAt),
      ]);
    final rows = await query.get();
    return rows.map(_fromRow).toList(growable: false);
  }

  @override
  Future<Goal> add(Goal goal) async {
    await _db.into(_db.goalsTable).insert(_toCompanion(goal));
    return goal;
  }

  @override
  Future<void> update(Goal goal) async {
    await (_db.update(_db.goalsTable)..where((t) => t.id.equals(goal.id)))
        .write(_toCompanion(goal));
  }

  @override
  Future<void> delete(String id) async {
    await (_db.delete(_db.goalsTable)..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<void> clear() async {
    await _db.delete(_db.goalsTable).go();
  }

  Goal _fromRow(GoalRow r) => Goal(
        id: r.id,
        goalCategoryId: r.goalCategoryId,
        title: r.title,
        starred: r.starred,
        addedAt: r.addedAt,
      );

  GoalsTableCompanion _toCompanion(Goal g) => GoalsTableCompanion(
        id: Value(g.id),
        goalCategoryId: Value(g.goalCategoryId),
        title: Value(g.title),
        starred: Value(g.starred),
        addedAt: Value(g.addedAt),
      );
}
