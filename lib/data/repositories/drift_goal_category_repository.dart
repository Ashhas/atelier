import 'package:atelier/data/drift/atelier_database.dart';
import 'package:atelier/domain/models/goal_category.dart';
import 'package:atelier/domain/repositories/goal_category_repository.dart';
import 'package:drift/drift.dart';

class DriftGoalCategoryRepository implements GoalCategoryRepository {
  DriftGoalCategoryRepository(this._db);

  final AtelierDatabase _db;

  @override
  Future<List<GoalCategory>> all() async {
    final query = _db.select(_db.goalCategoriesTable)
      ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]);
    final rows = await query.get();
    return rows.map(_fromRow).toList(growable: false);
  }

  @override
  Future<GoalCategory> add(GoalCategory category) async {
    await _db.into(_db.goalCategoriesTable).insert(_toCompanion(category));
    return category;
  }

  @override
  Future<void> update(GoalCategory category) async {
    await (_db.update(
      _db.goalCategoriesTable,
    )..where((t) => t.id.equals(category.id))).write(_toCompanion(category));
  }

  @override
  Future<void> delete(String id) async {
    await (_db.delete(
      _db.goalCategoriesTable,
    )..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<void> reorder(List<String> idsInNewOrder) async {
    await _db.transaction(() async {
      for (var i = 0; i < idsInNewOrder.length; i++) {
        await (_db.update(_db.goalCategoriesTable)
              ..where((t) => t.id.equals(idsInNewOrder[i])))
            .write(GoalCategoriesTableCompanion(sortOrder: Value(i)));
      }
    });
  }

  @override
  Future<void> clear() async {
    await _db.delete(_db.goalCategoriesTable).go();
  }

  GoalCategory _fromRow(GoalCategoryRow r) => GoalCategory(
    id: r.id,
    name: r.name,
    order: r.sortOrder,
    isAddSlot: r.isAddSlot,
  );

  GoalCategoriesTableCompanion _toCompanion(GoalCategory c) =>
      GoalCategoriesTableCompanion(
        id: Value(c.id),
        name: Value(c.name),
        sortOrder: Value(c.order),
        isAddSlot: Value(c.isAddSlot),
      );
}
