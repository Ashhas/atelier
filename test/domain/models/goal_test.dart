import 'package:atelier/domain/models/goal.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Goal', () {
    final addedAt = DateTime.utc(2026, 5, 1, 10);

    test('constructs with required fields and defaults starred=false', () {
      final g = Goal(
        id: 'g1',
        goalCategoryId: 'c1',
        title: 'Sub-25 5K',
        addedAt: addedAt,
      );
      expect(g.id, 'g1');
      expect(g.goalCategoryId, 'c1');
      expect(g.title, 'Sub-25 5K');
      expect(g.starred, isFalse);
      expect(g.addedAt, addedAt);
    });

    test('value equality across all fields', () {
      final a = Goal(id: 'g', goalCategoryId: 'c', title: 't', addedAt: addedAt);
      final b = Goal(id: 'g', goalCategoryId: 'c', title: 't', addedAt: addedAt);
      expect(a, equals(b));
    });

    test('copyWith for starred + title', () {
      final g = Goal(id: 'g', goalCategoryId: 'c', title: 't', addedAt: addedAt);
      expect(g.copyWith(starred: true).starred, isTrue);
      expect(g.copyWith(title: 'new').title, 'new');
    });
  });
}
