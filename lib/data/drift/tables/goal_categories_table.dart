import 'package:drift/drift.dart';

@DataClassName('GoalCategoryRow')
class GoalCategoriesTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get sortOrder => integer()();
  BoolColumn get isAddSlot => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  String? get tableName => 'goal_categories';
}
