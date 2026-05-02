import 'package:atelier/data/drift/atelier_database.dart';
import 'package:atelier/data/repositories/drift_goal_category_repository.dart';
import 'package:atelier/data/repositories/drift_year_goal_repository.dart';
import 'package:atelier/domain/models/goal_category.dart';
import 'package:atelier/presentation/features/detail/state/year_goals_cubit.dart';
import 'package:atelier/presentation/features/detail/state/year_goals_state.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AtelierDatabase db;
  late DriftYearGoalRepository repo;

  setUp(() async {
    db = AtelierDatabase.withExecutor(NativeDatabase.memory());
    final cats = DriftGoalCategoryRepository(db);
    await cats.add(const GoalCategory(id: 'cat-a', name: 'Body', order: 0));
    repo = DriftYearGoalRepository(db);
  });

  tearDown(() async => db.close());

  test('add then forCategory returns the new year goal expanded', () async {
    final cubit = YearGoalsCubit(repo);
    await cubit.load();
    await cubit.add(goalCategoryId: 'cat-a', title: 'Sub-22 5K');
    expect(cubit.state.forCategory('cat-a').single.title, 'Sub-22 5K');
    expect(cubit.state.forCategory('cat-a').single.expanded, isTrue);
  });

  test('toggleExpanded flips the expanded flag', () async {
    final cubit = YearGoalsCubit(repo);
    await cubit.load();
    await cubit.add(goalCategoryId: 'cat-a', title: 't');
    final id = cubit.state.forCategory('cat-a').single.id;
    await cubit.toggleExpanded(id);
    expect(cubit.state.forCategory('cat-a').single.expanded, isFalse);
    await cubit.toggleExpanded(id);
    expect(cubit.state.forCategory('cat-a').single.expanded, isTrue);
  });

  test('delete removes the year goal', () async {
    final cubit = YearGoalsCubit(repo);
    await cubit.load();
    await cubit.add(goalCategoryId: 'cat-a', title: 't');
    final id = cubit.state.forCategory('cat-a').single.id;
    await cubit.delete(id);
    expect(cubit.state.forCategory('cat-a'), isEmpty);
  });
}
