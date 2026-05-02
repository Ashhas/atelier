import 'package:atelier/domain/models/goal.dart';
import 'package:atelier/presentation/features/detail/widgets/goals/goal_row.dart';
import 'package:atelier/presentation/features/detail/widgets/goals/goal_row_actions.dart';
import 'package:atelier/presentation/features/detail/widgets/goals/goal_row_editor.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) => MaterialApp(
  theme: AtelierTheme.light(),
  home: Scaffold(body: SingleChildScrollView(child: child)),
);

final _goal = Goal(
  id: 'g1',
  goalCategoryId: 'cat1',
  title: 'Sub-25 5K',
  addedAt: DateTime.now(),
);

void main() {
  group('GoalRow', () {
    testWidgets('renders goal title', (tester) async {
      await tester.pumpWidget(
        _wrap(
          GoalRow(
            goal: _goal,
            isLast: false,
            onToggleStar: () {},
            onRename: (_) {},
            onDelete: () {},
          ),
        ),
      );
      expect(find.text('Sub-25 5K'), findsOneWidget);
    });

    testWidgets('tap row expands to show GoalRowActions', (tester) async {
      await tester.pumpWidget(
        _wrap(
          GoalRow(
            goal: _goal,
            isLast: false,
            onToggleStar: () {},
            onRename: (_) {},
            onDelete: () {},
          ),
        ),
      );
      expect(find.byType(GoalRowActions), findsNothing);
      await tester.tap(find.text('Sub-25 5K'));
      await tester.pumpAndSettle();
      expect(find.byType(GoalRowActions), findsOneWidget);
    });

    testWidgets('tapping row again collapses actions', (tester) async {
      await tester.pumpWidget(
        _wrap(
          GoalRow(
            goal: _goal,
            isLast: false,
            onToggleStar: () {},
            onRename: (_) {},
            onDelete: () {},
          ),
        ),
      );
      await tester.tap(find.text('Sub-25 5K'));
      await tester.pumpAndSettle();
      expect(find.byType(GoalRowActions), findsOneWidget);
      await tester.tap(find.text('Sub-25 5K'));
      await tester.pumpAndSettle();
      expect(find.byType(GoalRowActions), findsNothing);
    });

    testWidgets('Edit button switches to GoalRowEditor', (tester) async {
      await tester.pumpWidget(
        _wrap(
          GoalRow(
            goal: _goal,
            isLast: false,
            onToggleStar: () {},
            onRename: (_) {},
            onDelete: () {},
          ),
        ),
      );
      await tester.tap(find.text('Sub-25 5K'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('EDIT'));
      await tester.pumpAndSettle();
      expect(find.byType(GoalRowEditor), findsOneWidget);
    });

    testWidgets('Save in editor calls onRename', (tester) async {
      String? renamed;
      await tester.pumpWidget(
        _wrap(
          GoalRow(
            goal: _goal,
            isLast: false,
            onToggleStar: () {},
            onRename: (t) => renamed = t,
            onDelete: () {},
          ),
        ),
      );
      await tester.tap(find.text('Sub-25 5K'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('EDIT'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Sub-24 5K');
      await tester.tap(find.text('SAVE'));
      await tester.pumpAndSettle();
      expect(renamed, equals('Sub-24 5K'));
    });

    testWidgets('star button calls onToggleStar', (tester) async {
      var called = false;
      await tester.pumpWidget(
        _wrap(
          GoalRow(
            goal: _goal,
            isLast: false,
            onToggleStar: () => called = true,
            onRename: (_) {},
            onDelete: () {},
          ),
        ),
      );
      // Star button text: '☆' when not starred
      await tester.tap(find.text('☆'));
      expect(called, isTrue);
    });

    testWidgets('days label shows today for goal added today', (tester) async {
      await tester.pumpWidget(
        _wrap(
          GoalRow(
            goal: _goal,
            isLast: false,
            onToggleStar: () {},
            onRename: (_) {},
            onDelete: () {},
          ),
        ),
      );
      expect(find.text('today'), findsOneWidget);
    });
  });
}
