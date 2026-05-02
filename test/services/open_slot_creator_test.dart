import 'package:atelier/data/drift/atelier_database.dart';
import 'package:atelier/data/repositories/drift_goal_category_repository.dart';
import 'package:atelier/domain/models/goal_category.dart';
import 'package:atelier/services/open_slot_creator.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AtelierDatabase db;
  late DriftGoalCategoryRepository repo;
  late OpenSlotCreator creator;

  setUp(() {
    db = AtelierDatabase.withExecutor(NativeDatabase.memory());
    repo = DriftGoalCategoryRepository(db);
    creator = OpenSlotCreator(repo);
  });

  tearDown(() async => db.close());

  test('addFirstPocket creates the user pocket AND the Open slot', () async {
    final created = await creator.addFirstPocket(name: 'Work');

    final rows = await repo.all();
    expect(rows.length, 2);
    expect(rows.first.id, created.id);
    expect(rows.first.name, 'Work');
    expect(rows.first.order, 0);
    expect(rows.first.isAddSlot, isFalse);
    expect(rows.last.name, 'Open');
    expect(rows.last.isAddSlot, isTrue);
    expect(rows.last.order, greaterThan(rows.first.order));
  });

  test('addPocket on a non-empty store appends before the Open slot', () async {
    await creator.addFirstPocket(name: 'Work');
    final body = await creator.addPocket(name: 'Body');

    final rows = await repo.all();
    final names = rows.map((r) => r.name).toList();
    expect(names, ['Work', 'Body', 'Open']);
    expect(rows.firstWhere((r) => r.id == body.id).order, 1);
    expect(rows.firstWhere((r) => r.isAddSlot).order, 2);
  });

  test(
    'removePocket of the last real pocket also removes the Open slot',
    () async {
      final work = await creator.addFirstPocket(name: 'Work');
      await creator.removePocket(work.id);
      expect(await repo.all(), isEmpty);
    },
  );

  test(
    'removePocket when other real pockets remain keeps the Open slot',
    () async {
      final work = await creator.addFirstPocket(name: 'Work');
      await creator.addPocket(name: 'Body');
      await creator.removePocket(work.id);

      final rows = await repo.all();
      expect(rows.map((r) => r.name).toList(), ['Body', 'Open']);
    },
  );
}
