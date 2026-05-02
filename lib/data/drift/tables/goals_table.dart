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

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  String? get tableName => 'goals';
}
