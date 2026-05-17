// Exercises the v1 → v2 migration's backfill logic in isolation.
//
// We can't easily simulate Drift's `addColumn` from a real v1 schema
// snapshot here (no schemas/ dump infrastructure), but the application
// risk lives in the backfill ordering — that the prior implicit-sort
// (starred desc, addedAt asc) is preserved per category. We seed a v2
// DB with all rows at sort_order = 0 (the state immediately after
// addColumn writes the column default for every existing row), then
// call backfillGoalsSortOrder() and assert the result.

import 'package:atelier/data/drift/atelier_database.dart';
import 'package:atelier/data/repositories/drift_goal_category_repository.dart';
import 'package:atelier/domain/models/goal_category.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AtelierDatabase db;
  late DriftGoalCategoryRepository categories;

  setUp(() async {
    db = AtelierDatabase.withExecutor(NativeDatabase.memory());
    categories = DriftGoalCategoryRepository(db);
    await categories.add(const GoalCategory(id: 'cat-a', name: 'A', order: 0));
    await categories.add(const GoalCategory(id: 'cat-b', name: 'B', order: 1));
  });

  tearDown(() async => db.close());

  // Insert raw rows with sort_order = 0 for every row, mirroring the
  // post-addColumn state. Bypass the repository so we control sort_order
  // directly.
  Future<void> seedRaw({
    required String id,
    required String catId,
    required bool starred,
    required DateTime addedAt,
  }) async {
    await db
        .into(db.goalsTable)
        .insert(
          GoalsTableCompanion.insert(
            id: id,
            goalCategoryId: catId,
            title: 'Title $id',
            addedAt: addedAt,
            starred: Value(starred),
            sortOrder: const Value(0),
          ),
        );
  }

  Future<List<({String id, int sortOrder})>> sortOrders(String catId) async {
    final rows =
        await (db.select(db.goalsTable)
              ..where((t) => t.goalCategoryId.equals(catId))
              ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
            .get();
    return rows.map((r) => (id: r.id, sortOrder: r.sortOrder)).toList();
  }

  test('backfill orders starred goals first within each category', () async {
    // cat-a: 3 goals, mixed star + addedAt.
    await seedRaw(
      id: 'a-1',
      catId: 'cat-a',
      starred: false,
      addedAt: DateTime.utc(2026, 5, 1),
    );
    await seedRaw(
      id: 'a-2',
      catId: 'cat-a',
      starred: true,
      addedAt: DateTime.utc(2026, 5, 3),
    );
    await seedRaw(
      id: 'a-3',
      catId: 'cat-a',
      starred: false,
      addedAt: DateTime.utc(2026, 5, 2),
    );
    await seedRaw(
      id: 'a-4',
      catId: 'cat-a',
      starred: true,
      addedAt: DateTime.utc(2026, 5, 1),
    );

    await db.backfillGoalsSortOrder();

    // Expected: starred first (a-4 then a-2 by addedAt asc), then
    // unstarred by addedAt asc (a-1 then a-3).
    final ordered = await sortOrders('cat-a');
    expect(ordered.map((r) => r.id).toList(), ['a-4', 'a-2', 'a-1', 'a-3']);
    expect(ordered.map((r) => r.sortOrder).toList(), [0, 1, 2, 3]);
  });

  test('backfill numbers each category independently from 0', () async {
    await seedRaw(
      id: 'a-1',
      catId: 'cat-a',
      starred: false,
      addedAt: DateTime.utc(2026, 5, 1),
    );
    await seedRaw(
      id: 'a-2',
      catId: 'cat-a',
      starred: false,
      addedAt: DateTime.utc(2026, 5, 2),
    );
    await seedRaw(
      id: 'b-1',
      catId: 'cat-b',
      starred: false,
      addedAt: DateTime.utc(2026, 5, 1),
    );
    await seedRaw(
      id: 'b-2',
      catId: 'cat-b',
      starred: false,
      addedAt: DateTime.utc(2026, 5, 2),
    );

    await db.backfillGoalsSortOrder();

    expect((await sortOrders('cat-a')).map((r) => r.sortOrder).toList(), [
      0,
      1,
    ]);
    expect((await sortOrders('cat-b')).map((r) => r.sortOrder).toList(), [
      0,
      1,
    ]);
  });

  test(
    'backfill is idempotent — running it twice produces the same order',
    () async {
      await seedRaw(
        id: 'a-1',
        catId: 'cat-a',
        starred: true,
        addedAt: DateTime.utc(2026, 5, 1),
      );
      await seedRaw(
        id: 'a-2',
        catId: 'cat-a',
        starred: false,
        addedAt: DateTime.utc(2026, 5, 2),
      );

      await db.backfillGoalsSortOrder();
      final first = (await sortOrders('cat-a')).map((r) => r.id).toList();
      await db.backfillGoalsSortOrder();
      final second = (await sortOrders('cat-a')).map((r) => r.id).toList();

      expect(second, equals(first));
    },
  );
}
