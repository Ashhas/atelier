import 'package:atelier/domain/models/goal.dart';
import 'package:atelier/presentation/features/detail/widgets/goals/goal_row.dart';
import 'package:atelier/presentation/features/detail/widgets/goals/goal_row_actions.dart';
import 'package:atelier/presentation/features/detail/widgets/goals/goal_row_editor.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Wraps a [GoalRow] in a host that owns `isExpanded`, mirroring how
/// `DetailScreen` drives a single-expanded-row contract in production.
class _GoalRowHost extends StatefulWidget {
  const _GoalRowHost({required this.goal, this.onToggleStar, this.onRename});

  final Goal goal;
  final VoidCallback? onToggleStar;
  final ValueChanged<String>? onRename;

  @override
  State<_GoalRowHost> createState() => _GoalRowHostState();
}

class _GoalRowHostState extends State<_GoalRowHost> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GoalRow(
      goal: widget.goal,
      isExpanded: _isExpanded,
      onToggleExpanded: () => setState(() => _isExpanded = !_isExpanded),
      onToggleStar: widget.onToggleStar ?? () {},
      onRename: widget.onRename ?? (_) {},
      onDelete: () {},
    );
  }
}

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
      await tester.pumpWidget(_wrap(_GoalRowHost(goal: _goal)));
      expect(find.text('Sub-25 5K'), findsOneWidget);
    });

    testWidgets('tap row expands to show GoalRowActions', (tester) async {
      await tester.pumpWidget(_wrap(_GoalRowHost(goal: _goal)));
      expect(find.byType(GoalRowActions), findsNothing);
      await tester.tap(find.text('Sub-25 5K'));
      await tester.pumpAndSettle();
      expect(find.byType(GoalRowActions), findsOneWidget);
    });

    testWidgets('tapping row again collapses actions', (tester) async {
      await tester.pumpWidget(_wrap(_GoalRowHost(goal: _goal)));
      await tester.tap(find.text('Sub-25 5K'));
      await tester.pumpAndSettle();
      expect(find.byType(GoalRowActions), findsOneWidget);
      await tester.tap(find.text('Sub-25 5K'));
      await tester.pumpAndSettle();
      expect(find.byType(GoalRowActions), findsNothing);
    });

    testWidgets('Edit button switches to GoalRowEditor', (tester) async {
      await tester.pumpWidget(_wrap(_GoalRowHost(goal: _goal)));
      await tester.tap(find.text('Sub-25 5K'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('EDIT'));
      await tester.pumpAndSettle();
      expect(find.byType(GoalRowEditor), findsOneWidget);
    });

    testWidgets('Save in editor calls onRename', (tester) async {
      String? renamed;
      await tester.pumpWidget(
        _wrap(_GoalRowHost(goal: _goal, onRename: (t) => renamed = t)),
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
        _wrap(_GoalRowHost(goal: _goal, onToggleStar: () => called = true)),
      );
      // Star button text: '☆' when not starred
      await tester.tap(find.text('☆'));
      expect(called, isTrue);
    });

    testWidgets('days label shows today for goal added today', (tester) async {
      await tester.pumpWidget(_wrap(_GoalRowHost(goal: _goal)));
      expect(find.text('today'), findsOneWidget);
    });
  });
}
