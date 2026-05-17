import 'package:atelier/data/drift/tables/goal_categories_table.dart';
import 'package:drift/drift.dart';

@DataClassName('GoalRow')
class GoalsTable extends Table {
  TextColumn get id => text()();
  TextColumn get goalCategoryId => text().references(
    GoalCategoriesTable,
    #id,
    onDelete: KeyAction.cascade,
  )();
  TextColumn get title => text()();
  BoolColumn get starred => boolean().withDefault(const Constant(false))();
  DateTimeColumn get addedAt => dateTime()();

  /// Manual per-category sort key. Backfilled from (starred desc, addedAt
  /// asc) on schema upgrade so existing data preserves its prior ordering.
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  String? get tableName => 'goals';
}
