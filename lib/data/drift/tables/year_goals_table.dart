import 'package:atelier/data/drift/tables/goal_categories_table.dart';
import 'package:drift/drift.dart';

@DataClassName('YearGoalRow')
class YearGoalsTable extends Table {
  TextColumn get id => text()();
  TextColumn get goalCategoryId => text().references(
    GoalCategoriesTable,
    #id,
    onDelete: KeyAction.cascade,
  )();
  TextColumn get title => text()();
  BoolColumn get expanded => boolean().withDefault(const Constant(true))();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  String? get tableName => 'year_goals';
}
