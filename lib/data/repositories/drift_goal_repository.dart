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
    final nextOrder = await _nextSortOrder(goal.goalCategoryId);
    await _db
        .into(_db.goalsTable)
        .insert(
          GoalsTableCompanion.insert(
            id: goal.id,
            goalCategoryId: goal.goalCategoryId,
            title: goal.title,
            addedAt: goal.addedAt,
            starred: Value(goal.starred),
            sortOrder: Value(nextOrder),
          ),
        );
    return goal;
  }

  @override
  Future<void> update(Goal goal) async {
    // Only write the mutable domain fields. sort_order is owned by the
    // data layer and untouched by renames or star toggles — repositioning
    // goes through reorder().
    await (_db.update(
      _db.goalsTable,
    )..where((t) => t.id.equals(goal.id))).write(
      GoalsTableCompanion(
        goalCategoryId: Value(goal.goalCategoryId),
        title: Value(goal.title),
        starred: Value(goal.starred),
        addedAt: Value(goal.addedAt),
      ),
    );
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
    // Verify the caller's id list exactly matches the rows we have for
    // this category. Mismatches indicate a stale snapshot — fail loudly
    // so the issue surfaces at the boundary instead of leaving the table
    // in a partially-renumbered state.
    final existingIds = (await byCategory(
      goalCategoryId,
    )).map((g) => g.id).toSet();
    final requested = orderedIds.toSet();
    if (existingIds.length != requested.length ||
        !existingIds.containsAll(requested)) {
      throw StateError(
        'reorder() id mismatch for category $goalCategoryId: '
        'expected ${existingIds.length} rows, got ${requested.length}',
      );
    }

    await _db.batch((b) {
      for (var i = 0; i < orderedIds.length; i++) {
        b.update(
          _db.goalsTable,
          GoalsTableCompanion(sortOrder: Value(i)),
          where: (t) => t.id.equals(orderedIds[i]),
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
  );
}
