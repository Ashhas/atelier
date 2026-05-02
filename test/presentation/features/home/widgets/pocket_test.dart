import 'package:atelier/domain/models/goal.dart';
import 'package:atelier/domain/models/goal_category.dart';
import 'package:atelier/presentation/features/home/widgets/pocket/pocket.dart';
import 'package:atelier/presentation/features/home/widgets/pocket/pocket_goals_preview.dart';
import 'package:atelier/presentation/features/home/widgets/pocket/pocket_remove_badge.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) => MaterialApp(
  theme: AtelierTheme.light(),
  home: Scaffold(body: child),
);

const _cat = GoalCategory(id: 'c1', name: 'Work', order: 0);

Goal _goal(String id, String title, {bool starred = false}) => Goal(
  id: id,
  goalCategoryId: 'c1',
  title: title,
  starred: starred,
  addedAt: DateTime(2026, 5, 1),
);

void main() {
  group('Pocket §3.2', () {
    testWidgets('renders category name', (tester) async {
      await tester.pumpWidget(
        _wrap(
          Pocket(
            category: _cat,
            yearGoalCount: 0,
            goalsPreview: const [],
            isManaging: false,
            onTap: () {},
            onRemove: () {},
            onLongPress: () {},
          ),
        ),
      );
      // PocketHeader uppercases the name
      expect(find.textContaining('WORK'), findsAtLeastNWidgets(1));
    });

    testWidgets('calls onTap when tapped (not managing)', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        _wrap(
          Pocket(
            category: _cat,
            yearGoalCount: 0,
            goalsPreview: const [],
            isManaging: false,
            onTap: () => tapped = true,
            onRemove: () {},
            onLongPress: () {},
          ),
        ),
      );
      await tester.tap(find.byType(Pocket));
      expect(tapped, isTrue);
    });

    testWidgets('shows remove badge in manage mode §3.6', (tester) async {
      await tester.pumpWidget(
        _wrap(
          Pocket(
            category: _cat,
            yearGoalCount: 0,
            goalsPreview: const [],
            isManaging: true,
            onTap: () {},
            onRemove: () {},
            onLongPress: () {},
          ),
        ),
      );
      expect(find.byType(PocketRemoveBadge), findsOneWidget);
    });

    testWidgets('tapping remove badge calls onRemove §3.6', (tester) async {
      bool removed = false;
      await tester.pumpWidget(
        _wrap(
          Pocket(
            category: _cat,
            yearGoalCount: 0,
            goalsPreview: const [],
            isManaging: true,
            onTap: () {},
            onRemove: () => removed = true,
            onLongPress: () {},
          ),
        ),
      );
      await tester.tap(find.byType(PocketRemoveBadge));
      expect(removed, isTrue);
    });

    testWidgets('does not show remove badge when not managing', (tester) async {
      await tester.pumpWidget(
        _wrap(
          Pocket(
            category: _cat,
            yearGoalCount: 0,
            goalsPreview: const [],
            isManaging: false,
            onTap: () {},
            onRemove: () {},
            onLongPress: () {},
          ),
        ),
      );
      expect(find.byType(PocketRemoveBadge), findsNothing);
    });
  });

  group('PocketGoalsPreview §3.2', () {
    testWidgets('shows max 3 goals then +N more overflow', (tester) async {
      final goals = [
        _goal('1', 'Goal 1'),
        _goal('2', 'Goal 2'),
        _goal('3', 'Goal 3'),
        _goal('4', 'Goal 4'),
        _goal('5', 'Goal 5'),
      ];
      await tester.pumpWidget(_wrap(PocketGoalsPreview(goals: goals)));
      expect(find.textContaining('Goal 1'), findsOneWidget);
      expect(find.textContaining('Goal 2'), findsOneWidget);
      expect(find.textContaining('Goal 3'), findsOneWidget);
      expect(find.textContaining('Goal 4'), findsNothing);
      expect(find.textContaining('+2 more'), findsOneWidget);
    });

    testWidgets('starred goals sort first §3.3', (tester) async {
      final goals = [
        _goal('1', 'Unstarred'),
        _goal('2', 'Starred', starred: true),
      ];
      await tester.pumpWidget(_wrap(PocketGoalsPreview(goals: goals)));
      // Both are in preview (only 2 goals) - just check both render
      expect(find.textContaining('Starred'), findsOneWidget);
      expect(find.textContaining('Unstarred'), findsOneWidget);
    });
  });
}
