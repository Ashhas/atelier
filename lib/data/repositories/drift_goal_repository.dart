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
        (t) => OrderingTerm.asc(t.goalCategoryId),
        (t) => OrderingTerm.asc(t.sortOrder),
      ]);
    final rows = await query.get();
    return rows.map(_fromRow).toList(growable: false);
  }

  @override
  Future<List<Goal>> byCategory(String goalCategoryId) async {
    final query = _db.select(_db.goalsTable)
      ..where((t) => t.goalCategoryId.equals(goalCategoryId))
      ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]);
    final rows = await query.get();
    return rows.map(_fromRow).toList(growable: false);
  }

  @override
  Future<Goal> add(Goal goal) async {
    // Assign the next sortOrder for this category at insert time so the
    // new goal lands at the bottom of the list. If the caller already set
    // sortOrder explicitly, respect that.
    final effectiveOrder = goal.sortOrder != 0
        ? goal.sortOrder
        : await _nextSortOrder(goal.goalCategoryId);
    final toInsert = goal.copyWith(sortOrder: effectiveOrder);
    await _db.into(_db.goalsTable).insert(_toCompanion(toInsert));
    return toInsert;
  }

  @override
  Future<void> update(Goal goal) async {
    await (_db.update(
      _db.goalsTable,
    )..where((t) => t.id.equals(goal.id))).write(_toCompanion(goal));
  }

  @override
  Future<void> delete(String id) async {
    await (_db.delete(_db.goalsTable)..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<void> clear() async {
    await _db.delete(_db.goalsTable).go();
  }

  @override
  Future<void> reorder({
    required String goalCategoryId,
    required List<String> orderedIds,
  }) async {
    await _db.batch((b) {
      for (var i = 0; i < orderedIds.length; i++) {
        b.update(
          _db.goalsTable,
          GoalsTableCompanion(sortOrder: Value(i)),
          where: (t) =>
              t.id.equals(orderedIds[i]) &
              t.goalCategoryId.equals(goalCategoryId),
        );
      }
    });
  }

  Future<int> _nextSortOrder(String goalCategoryId) async {
    final maxExpr = _db.goalsTable.sortOrder.max();
    final row =
        await (_db.selectOnly(_db.goalsTable)
              ..addColumns([maxExpr])
              ..where(_db.goalsTable.goalCategoryId.equals(goalCategoryId)))
            .getSingleOrNull();
    final current = row?.read(maxExpr);
    return current == null ? 0 : current + 1;
  }

  Goal _fromRow(GoalRow r) => Goal(
    id: r.id,
    goalCategoryId: r.goalCategoryId,
    title: r.title,
    starred: r.starred,
    addedAt: r.addedAt,
    sortOrder: r.sortOrder,
  );

  GoalsTableCompanion _toCompanion(Goal g) => GoalsTableCompanion(
    id: Value(g.id),
    goalCategoryId: Value(g.goalCategoryId),
    title: Value(g.title),
    starred: Value(g.starred),
    addedAt: Value(g.addedAt),
    sortOrder: Value(g.sortOrder),
  );
}
