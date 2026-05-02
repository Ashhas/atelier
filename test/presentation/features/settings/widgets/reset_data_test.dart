import 'package:atelier/presentation/features/settings/widgets/reset_data_button.dart';
import 'package:atelier/presentation/features/settings/widgets/reset_data_confirm.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) => MaterialApp(
  theme: AtelierTheme.light(),
  home: Scaffold(body: SingleChildScrollView(child: child)),
);

void main() {
  group('ResetDataButton §3.7', () {
    testWidgets('renders reset title and subtitle', (tester) async {
      await tester.pumpWidget(_wrap(ResetDataButton(onTap: () {})));
      expect(find.text('Reset all data'), findsOneWidget);
      expect(
        find.textContaining('Removes all goals'),
        findsOneWidget,
      );
    });

    testWidgets('tapping fires onTap callback', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        _wrap(ResetDataButton(onTap: () => tapped = true)),
      );
      await tester.tap(find.byType(ResetDataButton));
      expect(tapped, isTrue);
    });
  });

  group('ResetDataConfirm §3.7', () {
    testWidgets('renders confirmation title and subtitle', (tester) async {
      await tester.pumpWidget(
        _wrap(ResetDataConfirm(onReset: () {}, onCancel: () {})),
      );
      expect(find.text('Reset everything?'), findsOneWidget);
      expect(find.textContaining('All goals'), findsOneWidget);
    });

    testWidgets('tapping CANCEL fires onCancel', (tester) async {
      var cancelled = false;
      await tester.pumpWidget(
        _wrap(
          ResetDataConfirm(
            onReset: () {},
            onCancel: () => cancelled = true,
          ),
        ),
      );
      await tester.tap(find.text('CANCEL'));
      expect(cancelled, isTrue);
    });

    testWidgets('tapping RESET fires onReset callback', (tester) async {
      var reset = false;
      await tester.pumpWidget(
        _wrap(
          ResetDataConfirm(
            onReset: () => reset = true,
            onCancel: () {},
          ),
        ),
      );
      await tester.tap(find.text('RESET'));
      expect(reset, isTrue);
    });
  });
}
