import 'package:atelier/data/drift/atelier_database.dart';
import 'package:atelier/data/repositories/drift_goal_category_repository.dart';
import 'package:atelier/data/repositories/drift_goal_repository.dart';
import 'package:atelier/domain/models/goal.dart';
import 'package:atelier/domain/models/goal_category.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AtelierDatabase db;
  late DriftGoalRepository repo;
  late DriftGoalCategoryRepository categories;

  Future<void> seedCategory(String id) =>
      categories.add(GoalCategory(id: id, name: id, order: 0));

  setUp(() async {
    db = AtelierDatabase.withExecutor(NativeDatabase.memory());
    categories = DriftGoalCategoryRepository(db);
    repo = DriftGoalRepository(db);
    await seedCategory('cat-a');
    await seedCategory('cat-b');
  });

  tearDown(() async => db.close());

  Goal g(String id, String catId, {bool starred = false, DateTime? addedAt}) =>
      Goal(
        id: id,
        goalCategoryId: catId,
        title: 'Title $id',
        starred: starred,
        addedAt: addedAt ?? DateTime.utc(2026, 5, 1),
      );

  test('add + byCategory returns matching rows only', () async {
    await repo.add(g('1', 'cat-a'));
    await repo.add(g('2', 'cat-b'));
    final rowsA = await repo.byCategory('cat-a');
    expect(rowsA.map((e) => e.id), ['1']);
  });

  test('byCategory sorts by sortOrder ascending (insertion order)', () async {
    // add() auto-assigns sortOrder = max+1, so insertion order is preserved
    // regardless of starred state or addedAt.
    await repo.add(g('1', 'cat-a', addedAt: DateTime.utc(2026, 5, 1)));
    await repo.add(
      g('2', 'cat-a', starred: true, addedAt: DateTime.utc(2026, 5, 3)),
    );
    await repo.add(g('3', 'cat-a', addedAt: DateTime.utc(2026, 5, 2)));
    await repo.add(
      g('4', 'cat-a', starred: true, addedAt: DateTime.utc(2026, 5, 1)),
    );

    final ordered = await repo.byCategory('cat-a');
    expect(ordered.map((e) => e.id).toList(), ['1', '2', '3', '4']);
  });

  test('reorder rewrites sortOrder to match the given id list', () async {
    await repo.add(g('1', 'cat-a'));
    await repo.add(g('2', 'cat-a'));
    await repo.add(g('3', 'cat-a'));
    await repo.add(g('4', 'cat-a'));

    await repo.reorder(
      goalCategoryId: 'cat-a',
      orderedIds: const ['4', '2', '1', '3'],
    );

    expect((await repo.byCategory('cat-a')).map((e) => e.id).toList(), [
      '4',
      '2',
      '1',
      '3',
    ]);
  });

  test('reorder throws if the id list is missing a row', () async {
    await repo.add(g('1', 'cat-a'));
    await repo.add(g('2', 'cat-a'));
    await repo.add(g('3', 'cat-a'));

    expect(
      () => repo.reorder(
        goalCategoryId: 'cat-a',
        orderedIds: const ['1', '2'],
      ),
      throwsStateError,
    );
  });

  test('reorder throws if the id list contains a stranger', () async {
    await repo.add(g('1', 'cat-a'));
    await repo.add(g('2', 'cat-a'));
    // 'x' isn't in cat-a.
    expect(
      () => repo.reorder(
        goalCategoryId: 'cat-a',
        orderedIds: const ['1', '2', 'x'],
      ),
      throwsStateError,
    );
  });

  test('toggleStar (via update) preserves position in the list', () async {
    await repo.add(g('1', 'cat-a'));
    await repo.add(g('2', 'cat-a'));
    await repo.add(g('3', 'cat-a'));

    // Star the middle goal — it should stay in the middle, not jump to top.
    final two = (await repo.byCategory('cat-a'))[1];
    await repo.update(two.copyWith(starred: true));

    expect((await repo.byCategory('cat-a')).map((e) => e.id).toList(), [
      '1',
      '2',
      '3',
    ]);
  });

  test('update changes title + starred', () async {
    await repo.add(g('1', 'cat-a'));
    final updated = (await repo.byCategory(
      'cat-a',
    )).single.copyWith(title: 'Renamed', starred: true);
    await repo.update(updated);
    expect((await repo.byCategory('cat-a')).single.title, 'Renamed');
    expect((await repo.byCategory('cat-a')).single.starred, isTrue);
  });

  test('delete removes the goal', () async {
    await repo.add(g('1', 'cat-a'));
    await repo.delete('1');
    expect(await repo.byCategory('cat-a'), isEmpty);
  });

  test('cascade delete: removing the category drops its goals', () async {
    await repo.add(g('1', 'cat-a'));
    await repo.add(g('2', 'cat-b'));
    await categories.delete('cat-a');
    expect(await repo.all(), hasLength(1));
    expect((await repo.all()).single.id, '2');
  });

  test('clear removes everything', () async {
    await repo.add(g('1', 'cat-a'));
    await repo.clear();
    expect(await repo.all(), isEmpty);
  });
}
