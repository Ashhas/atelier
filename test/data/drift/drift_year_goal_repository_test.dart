import 'package:atelier/data/drift/atelier_database.dart';
import 'package:atelier/data/repositories/drift_goal_category_repository.dart';
import 'package:atelier/data/repositories/drift_year_goal_repository.dart';
import 'package:atelier/domain/models/goal_category.dart';
import 'package:atelier/domain/models/year_goal.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AtelierDatabase db;
  late DriftYearGoalRepository repo;
  late DriftGoalCategoryRepository categories;

  setUp(() async {
    db = AtelierDatabase.withExecutor(NativeDatabase.memory());
    categories = DriftGoalCategoryRepository(db);
    repo = DriftYearGoalRepository(db);
    await categories.add(
      const GoalCategory(id: 'cat-a', name: 'Body', order: 0),
    );
    await categories.add(
      const GoalCategory(id: 'cat-b', name: 'Mind', order: 1),
    );
  });

  tearDown(() async => db.close());

  test('add + byCategory', () async {
    await repo.add(
      const YearGoal(id: 'y1', goalCategoryId: 'cat-a', title: 'Sub-22 5K'),
    );
    final rows = await repo.byCategory('cat-a');
    expect(rows.single.title, 'Sub-22 5K');
    expect(rows.single.expanded, isTrue);
  });

  test('update toggles expanded', () async {
    await repo.add(
      const YearGoal(id: 'y1', goalCategoryId: 'cat-a', title: 't'),
    );
    await repo.update(
      const YearGoal(
        id: 'y1',
        goalCategoryId: 'cat-a',
        title: 't',
        expanded: false,
      ),
    );
    expect((await repo.byCategory('cat-a')).single.expanded, isFalse);
  });

  test('cascade delete drops year-goals', () async {
    await repo.add(
      const YearGoal(id: 'y1', goalCategoryId: 'cat-a', title: 't'),
    );
    await categories.delete('cat-a');
    expect(await repo.all(), isEmpty);
  });

  test('clear removes everything', () async {
    await repo.add(
      const YearGoal(id: 'y1', goalCategoryId: 'cat-a', title: 't'),
    );
    await repo.clear();
    expect(await repo.all(), isEmpty);
  });
}
