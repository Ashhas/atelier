import 'package:atelier/domain/models/year_goal.dart';
import 'package:atelier/presentation/features/detail/widgets/year_banner/year_banner.dart';
import 'package:atelier/presentation/features/detail/widgets/year_banner/year_banner_collapsed.dart';
import 'package:atelier/presentation/features/detail/widgets/year_banner/year_banner_empty_state.dart';
import 'package:atelier/presentation/features/detail/widgets/year_banner/year_banner_expanded.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) => MaterialApp(
  theme: AtelierTheme.light(),
  home: Scaffold(body: child),
);

const _goal = YearGoal(
  id: 'yg1',
  goalCategoryId: 'cat1',
  title: 'Run a marathon',
  expanded: true,
);

void main() {
  group('YearBanner', () {
    testWidgets('shows empty state when yearGoal is null', (tester) async {
      await tester.pumpWidget(
        _wrap(
          YearBanner(
            yearGoal: null,
            categoryName: 'Body',
            onToggle: (_) {},
            onDelete: (_) {},
            onRename: (_, __) {},
          ),
        ),
      );
      expect(find.byType(YearBannerEmptyState), findsOneWidget);
      expect(find.textContaining('Body'), findsWidgets);
    });

    testWidgets('shows expanded banner when expanded=true', (tester) async {
      await tester.pumpWidget(
        _wrap(
          YearBanner(
            yearGoal: _goal,
            categoryName: 'Body',
            onToggle: (_) {},
            onDelete: (_) {},
            onRename: (_, __) {},
          ),
        ),
      );
      expect(find.byType(YearBannerExpanded), findsOneWidget);
      expect(find.text('Run a marathon'), findsOneWidget);
    });

    testWidgets('shows collapsed banner when expanded=false', (tester) async {
      const collapsed = YearGoal(
        id: 'yg2',
        goalCategoryId: 'cat1',
        title: 'Learn Italian',
        expanded: false,
      );
      await tester.pumpWidget(
        _wrap(
          YearBanner(
            yearGoal: collapsed,
            categoryName: 'Skill',
            onToggle: (_) {},
            onDelete: (_) {},
            onRename: (_, __) {},
          ),
        ),
      );
      expect(find.byType(YearBannerCollapsed), findsOneWidget);
      expect(find.text('Learn Italian'), findsOneWidget);
    });

    testWidgets('expanded banner calls onToggle when tapped', (tester) async {
      String? toggled;
      await tester.pumpWidget(
        _wrap(
          YearBanner(
            yearGoal: _goal,
            categoryName: 'Body',
            onToggle: (id) => toggled = id,
            onDelete: (_) {},
            onRename: (_, __) {},
          ),
        ),
      );
      // Tap the expanded banner body (not the × button)
      await tester.tap(find.byType(YearBannerExpanded));
      expect(toggled, equals('yg1'));
    });

    testWidgets('expanded banner × button calls onDelete', (tester) async {
      String? deleted;
      await tester.pumpWidget(
        _wrap(
          YearBanner(
            yearGoal: _goal,
            categoryName: 'Body',
            onToggle: (_) {},
            onDelete: (id) => deleted = id,
            onRename: (_, __) {},
          ),
        ),
      );
      await tester.tap(find.text('×'));
      expect(deleted, equals('yg1'));
    });

    testWidgets(
      'expanded banner ✎ button enters edit mode, SAVE pill calls onRename',
      (tester) async {
        String? renamedId;
        String? renamedTitle;
        await tester.pumpWidget(
          _wrap(
            YearBanner(
              yearGoal: _goal,
              categoryName: 'Body',
              onToggle: (_) {},
              onDelete: (_) {},
              onRename: (id, title) {
                renamedId = id;
                renamedTitle = title;
              },
            ),
          ),
        );
        // Enter edit mode via the ✎ pencil button.
        await tester.tap(find.text('✎'));
        await tester.pumpAndSettle();
        // Editing UI is visible; pencil and × are hidden.
        expect(find.byType(TextField), findsOneWidget);
        expect(find.text('SAVE'), findsOneWidget);
        expect(find.text('CANCEL'), findsOneWidget);
        expect(find.text('✎'), findsNothing);
        expect(find.text('×'), findsNothing);
        // Edit the title and save.
        await tester.enterText(find.byType(TextField), 'Run two marathons');
        await tester.tap(find.text('SAVE'));
        await tester.pumpAndSettle();
        expect(renamedId, equals('yg1'));
        expect(renamedTitle, equals('Run two marathons'));
        // Edit UI is gone.
        expect(find.byType(TextField), findsNothing);
      },
    );

    testWidgets('CANCEL pill exits edit mode without calling onRename', (
      tester,
    ) async {
      var renameCalls = 0;
      await tester.pumpWidget(
        _wrap(
          YearBanner(
            yearGoal: _goal,
            categoryName: 'Body',
            onToggle: (_) {},
            onDelete: (_) {},
            onRename: (_, __) => renameCalls++,
          ),
        ),
      );
      await tester.tap(find.text('✎'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'will be discarded');
      await tester.tap(find.text('CANCEL'));
      await tester.pumpAndSettle();
      expect(renameCalls, equals(0));
      expect(find.byType(TextField), findsNothing);
      expect(find.text('Run a marathon'), findsOneWidget);
    });

    testWidgets('collapsed banner calls onToggle when tapped', (tester) async {
      const collapsed = YearGoal(
        id: 'yg3',
        goalCategoryId: 'cat1',
        title: 'Tonal harmony',
        expanded: false,
      );
      String? toggled;
      await tester.pumpWidget(
        _wrap(
          YearBanner(
            yearGoal: collapsed,
            categoryName: 'Skill',
            onToggle: (id) => toggled = id,
            onDelete: (_) {},
            onRename: (_, __) {},
          ),
        ),
      );
      await tester.tap(find.byType(YearBannerCollapsed));
      expect(toggled, equals('yg3'));
    });
  });
}
