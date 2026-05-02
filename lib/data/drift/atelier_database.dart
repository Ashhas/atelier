import 'dart:io';

import 'package:atelier/data/drift/tables/goal_categories_table.dart';
import 'package:atelier/data/drift/tables/goals_table.dart';
import 'package:atelier/data/drift/tables/year_goals_table.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'atelier_database.g.dart';

@DriftDatabase(tables: [GoalCategoriesTable, GoalsTable, YearGoalsTable])
class AtelierDatabase extends _$AtelierDatabase {
  AtelierDatabase() : super(_open());

  /// For tests — pass an in-memory or custom executor.
  // ignore: use_super_parameters
  AtelierDatabase.withExecutor(QueryExecutor executor) : super(executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async => m.createAll(),
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}

LazyDatabase _open() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'atelier.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
