import 'package:atelier/presentation/features/detail/widgets/top_bar/detail_back_button.dart';
import 'package:atelier/presentation/features/detail/widgets/top_bar/detail_count_label.dart';
import 'package:atelier/presentation/features/detail/widgets/top_bar/detail_top_bar.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) => MaterialApp(
  theme: AtelierTheme.light(),
  home: Scaffold(body: child),
);

void main() {
  group('DetailTopBar', () {
    testWidgets('renders category name, month count, and year count', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          DetailTopBar(
            name: 'Body',
            monthCount: 3,
            yearCount: 1,
            onBack: () {},
          ),
        ),
      );
      expect(find.text('Body'), findsOneWidget);
      expect(find.textContaining('3'), findsWidgets);
      expect(find.textContaining('month'), findsWidgets);
      expect(find.textContaining('1'), findsWidgets);
      expect(find.textContaining('year'), findsWidgets);
    });

    testWidgets('back button calls onBack callback', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        _wrap(
          DetailTopBar(
            name: 'Work',
            monthCount: 2,
            yearCount: 0,
            onBack: () => tapped = true,
          ),
        ),
      );
      await tester.tap(find.byType(DetailBackButton));
      expect(tapped, isTrue);
    });

    testWidgets('DetailCountLabel shows correct format', (tester) async {
      await tester.pumpWidget(
        _wrap(const DetailCountLabel(monthCount: 5, yearCount: 2)),
      );
      expect(find.textContaining('5'), findsWidgets);
      expect(find.textContaining('month'), findsWidgets);
      expect(find.textContaining('2'), findsWidgets);
      expect(find.textContaining('year'), findsWidgets);
    });
  });
}
