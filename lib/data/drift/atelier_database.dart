import 'dart:io';

import 'package:atelier/data/drift/tables/goal_categories_table.dart';
import 'package:atelier/data/drift/tables/goals_table.dart';
import 'package:atelier/data/drift/tables/year_goals_table.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
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
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        // v2 adds goals.sort_order. Drift's addColumn issues
        // ALTER TABLE ... ADD COLUMN with the column's declared default,
        // so existing rows land with sort_order = 0. We then backfill
        // per-category orderings from the previous implicit sort
        // (starred desc, addedAt asc, id asc) so users don't see their
        // list shuffle on first launch after upgrade.
        await m.addColumn(goalsTable, goalsTable.sortOrder);
        await backfillGoalsSortOrder();
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  /// Rewrites `goals.sort_order` for every row, partitioned by category,
  /// using the prior implicit-sort order (starred desc, addedAt asc, id asc).
  /// Called once from the v1→v2 migration; exposed for direct testing of
  /// the backfill logic against a freshly-seeded DB.
  @visibleForTesting
  Future<void> backfillGoalsSortOrder() async {
    // Fetch all rows, group by category, assign 0..N-1 in the existing
    // implicit-sort order. The whole loop runs in one batch so a crash
    // mid-migration leaves the DB at v1, not half-migrated.
    final all =
        await (select(goalsTable)..orderBy([
              (t) => OrderingTerm.asc(t.goalCategoryId),
              (t) => OrderingTerm.desc(t.starred),
              (t) => OrderingTerm.asc(t.addedAt),
              (t) => OrderingTerm.asc(t.id),
            ]))
            .get();

    await batch((b) {
      String? currentCategory;
      var index = 0;
      for (final row in all) {
        if (row.goalCategoryId != currentCategory) {
          currentCategory = row.goalCategoryId;
          index = 0;
        }
        b.update(
          goalsTable,
          GoalsTableCompanion(sortOrder: Value(index)),
          where: (t) => t.id.equals(row.id),
        );
        index += 1;
      }
    });
  }
}

LazyDatabase _open() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'atelier.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
