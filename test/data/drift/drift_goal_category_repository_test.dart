import 'package:atelier/data/drift/atelier_database.dart';
import 'package:atelier/data/repositories/drift_goal_category_repository.dart';
import 'package:atelier/domain/models/goal_category.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

AtelierDatabase _inMemory() =>
    AtelierDatabase.withExecutor(NativeDatabase.memory());

void main() {
  late AtelierDatabase db;
  late DriftGoalCategoryRepository repo;

  setUp(() {
    db = _inMemory();
    repo = DriftGoalCategoryRepository(db);
  });

  tearDown(() async => db.close());

  test('all() returns empty list initially', () async {
    expect(await repo.all(), isEmpty);
  });

  test('add then all() returns the row', () async {
    const c = GoalCategory(id: 'c1', name: 'Work', order: 0);
    await repo.add(c);
    expect(await repo.all(), [c]);
  });

  test('all() is sorted by order ascending', () async {
    await repo.add(const GoalCategory(id: 'a', name: 'A', order: 2));
    await repo.add(const GoalCategory(id: 'b', name: 'B', order: 0));
    await repo.add(const GoalCategory(id: 'c', name: 'C', order: 1));
    final ordered = await repo.all();
    expect(ordered.map((c) => c.id).toList(), ['b', 'c', 'a']);
  });

  test('update changes name + order', () async {
    await repo.add(const GoalCategory(id: 'c1', name: 'Old', order: 0));
    await repo.update(const GoalCategory(id: 'c1', name: 'New', order: 5));
    final list = await repo.all();
    expect(list.single, const GoalCategory(id: 'c1', name: 'New', order: 5));
  });

  test('delete removes the row', () async {
    await repo.add(const GoalCategory(id: 'c1', name: 'Work', order: 0));
    await repo.delete('c1');
    expect(await repo.all(), isEmpty);
  });

  test('reorder updates order to match the supplied id list', () async {
    await repo.add(const GoalCategory(id: 'a', name: 'A', order: 0));
    await repo.add(const GoalCategory(id: 'b', name: 'B', order: 1));
    await repo.add(const GoalCategory(id: 'c', name: 'C', order: 2));
    await repo.reorder(['c', 'a', 'b']);
    final list = await repo.all();
    expect(list.map((c) => c.id).toList(), ['c', 'a', 'b']);
    expect(list.map((c) => c.order).toList(), [0, 1, 2]);
  });

  test('clear removes everything', () async {
    await repo.add(const GoalCategory(id: 'a', name: 'A', order: 0));
    await repo.clear();
    expect(await repo.all(), isEmpty);
  });

  test('isAddSlot round-trips', () async {
    await repo.add(
      const GoalCategory(id: 'open', name: 'Open', order: 99, isAddSlot: true),
    );
    expect((await repo.all()).single.isAddSlot, isTrue);
  });
}
