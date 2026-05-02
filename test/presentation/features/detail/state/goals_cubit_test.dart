import 'package:atelier/data/drift/atelier_database.dart';
import 'package:atelier/data/repositories/drift_goal_category_repository.dart';
import 'package:atelier/data/repositories/drift_goal_repository.dart';
import 'package:atelier/domain/models/goal_category.dart';
import 'package:atelier/presentation/features/detail/state/goals_cubit.dart';
import 'package:atelier/presentation/features/detail/state/goals_state.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AtelierDatabase db;
  late DriftGoalRepository repo;

  setUp(() async {
    db = AtelierDatabase.withExecutor(NativeDatabase.memory());
    final cats = DriftGoalCategoryRepository(db);
    await cats.add(const GoalCategory(id: 'cat-a', name: 'Body', order: 0));
    repo = DriftGoalRepository(db);
  });

  tearDown(() async => db.close());

  test('add then state.forCategory returns the goal', () async {
    final cubit = GoalsCubit(repo);
    final emitted = <GoalsState>[];
    final sub = cubit.stream.listen(emitted.add);
    await cubit.load();
    await cubit.add(goalCategoryId: 'cat-a', title: 'Strength 3×/wk');
    await Future<void>.delayed(Duration.zero);
    await sub.cancel();
    expect(emitted.last.forCategory('cat-a').map((g) => g.title).toList(), ['Strength 3×/wk']);
  });

  test('toggleStar promotes the goal in sort order', () async {
    final cubit = GoalsCubit(repo);
    await cubit.load();
    await cubit.add(goalCategoryId: 'cat-a', title: 'A');
    await cubit.add(goalCategoryId: 'cat-a', title: 'B');
    await cubit.add(goalCategoryId: 'cat-a', title: 'C');
    final b = cubit.state.forCategory('cat-a').firstWhere((g) => g.title == 'B');
    await cubit.toggleStar(b.id);
    final titles = cubit.state.forCategory('cat-a').map((g) => g.title).toList();
    expect(titles.first, 'B');
  });

  test('rename + delete work', () async {
    final cubit = GoalsCubit(repo);
    await cubit.load();
    await cubit.add(goalCategoryId: 'cat-a', title: 'old');
    final id = cubit.state.forCategory('cat-a').single.id;
    await cubit.rename(id: id, title: 'new');
    expect(cubit.state.forCategory('cat-a').single.title, 'new');
    await cubit.delete(id);
    expect(cubit.state.forCategory('cat-a'), isEmpty);
  });
}
