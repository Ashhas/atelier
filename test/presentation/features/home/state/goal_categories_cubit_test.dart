import 'package:atelier/data/drift/atelier_database.dart';
import 'package:atelier/data/repositories/drift_goal_category_repository.dart';
import 'package:atelier/presentation/features/home/state/goal_categories_cubit.dart';
import 'package:atelier/presentation/features/home/state/goal_categories_state.dart';
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

  test('load() emits a loaded empty state on a fresh DB', () async {
    final cubit = GoalCategoriesCubit(repo, creator);
    final emitted = <GoalCategoriesState>[];
    final sub = cubit.stream.listen(emitted.add);
    await cubit.load();
    await Future<void>.delayed(Duration.zero);
    await sub.cancel();
    expect(emitted, hasLength(1));
    expect(emitted.last.loaded, isTrue);
    expect(emitted.last.categories, isEmpty);
  });

  test(
    'addPocket on empty creates first pocket + Open slot and re-emits',
    () async {
      final cubit = GoalCategoriesCubit(repo, creator);
      final emitted = <GoalCategoriesState>[];
      final sub = cubit.stream.listen(emitted.add);
      await cubit.load();
      await cubit.addPocket('Work');
      await Future<void>.delayed(Duration.zero);
      await sub.cancel();
      // Skip the load() emission, check the addPocket emission
      final afterAdd = emitted.skip(1).toList();
      expect(afterAdd, hasLength(1));
      expect(afterAdd.last.categories.map((c) => c.name).toList(), [
        'Work',
        'Open',
      ]);
    },
  );

  test('removePocket on last real pocket removes Open too', () async {
    final cubit = GoalCategoriesCubit(repo, creator);
    final emitted = <GoalCategoriesState>[];
    final sub = cubit.stream.listen(emitted.add);
    await cubit.load();
    await cubit.addPocket('Work');
    final work = cubit.state.realCategories.first;
    await cubit.removePocket(work.id);
    await Future<void>.delayed(Duration.zero);
    await sub.cancel();
    final afterRemove = emitted.skip(2).toList();
    expect(afterRemove, hasLength(1));
    expect(afterRemove.last.categories, isEmpty);
  });

  test('reorder updates orders in disk + state', () async {
    final cubit = GoalCategoriesCubit(repo, creator);
    final emitted = <GoalCategoriesState>[];
    final sub = cubit.stream.listen(emitted.add);
    await cubit.load();
    await cubit.addPocket('A');
    await cubit.addPocket('B');
    await cubit.addPocket('C');
    final ids = cubit.state.realCategories.map((r) => r.id).toList();
    await cubit.reorder([ids[2], ids[0], ids[1]]);
    await Future<void>.delayed(Duration.zero);
    await sub.cancel();
    final afterReorder = emitted.skip(4).toList();
    expect(afterReorder, hasLength(1));
    expect(afterReorder.last.realCategories.map((c) => c.name).toList(), [
      'C',
      'A',
      'B',
    ]);
  });
}
