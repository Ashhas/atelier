import 'package:atelier/domain/models/year_goal.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('YearGoal', () {
    test('defaults to expanded=true', () {
      const yg = YearGoal(id: 'y1', goalCategoryId: 'c1', title: 'Run sub-22 5K');
      expect(yg.expanded, isTrue);
    });

    test('copyWith updates the chosen field', () {
      const yg = YearGoal(id: 'y1', goalCategoryId: 'c1', title: 't');
      expect(yg.copyWith(expanded: false).expanded, isFalse);
      expect(yg.copyWith(title: 'new').title, 'new');
    });

    test('value equality', () {
      const a = YearGoal(id: 'y', goalCategoryId: 'c', title: 't');
      const b = YearGoal(id: 'y', goalCategoryId: 'c', title: 't');
      expect(a, equals(b));
    });
  });
}
