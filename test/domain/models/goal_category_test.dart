import 'package:atelier/domain/models/goal_category.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GoalCategory', () {
    test('constructs with required fields and defaults isAddSlot=false', () {
      const c = GoalCategory(id: 'id-1', name: 'Work', order: 0);
      expect(c.id, 'id-1');
      expect(c.name, 'Work');
      expect(c.order, 0);
      expect(c.isAddSlot, isFalse);
    });

    test('value equality across all fields', () {
      const a = GoalCategory(id: 'id', name: 'Body', order: 2);
      const b = GoalCategory(id: 'id', name: 'Body', order: 2);
      expect(a, equals(b));

      const c = GoalCategory(id: 'id', name: 'Body', order: 3);
      expect(a, isNot(equals(c)));
    });

    test('copyWith updates the chosen fields only', () {
      const c = GoalCategory(id: 'id', name: 'Old', order: 0);
      final renamed = c.copyWith(name: 'New');
      expect(renamed.name, 'New');
      expect(renamed.order, 0);

      final reordered = c.copyWith(order: 5);
      expect(reordered.name, 'Old');
      expect(reordered.order, 5);
    });
  });
}
