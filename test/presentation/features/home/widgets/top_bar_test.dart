import 'package:atelier/presentation/features/home/widgets/top_bar/days_left_label.dart';
import 'package:atelier/presentation/features/home/widgets/top_bar/done_pill_button.dart';
import 'package:atelier/presentation/features/home/widgets/top_bar/home_top_bar.dart';
import 'package:atelier/presentation/features/home/widgets/top_bar/settings_gear_button.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) => MaterialApp(
  theme: AtelierTheme.light(),
  home: Scaffold(body: child),
);

void main() {
  group('HomeTopBar §3.1', () {
    testWidgets('renders month name and year from now', (tester) async {
      await tester.pumpWidget(
        _wrap(
          HomeTopBar(
            now: DateTime(2026, 5, 2),
            isManaging: false,
            onSettings: () {},
            onDone: () {},
          ),
        ),
      );
      expect(find.textContaining('May'), findsAtLeastNWidgets(1));
      expect(find.textContaining('2026'), findsAtLeastNWidgets(1));
    });

    testWidgets('shows DaysLeftLabel + settings gear when not managing §3.1', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          HomeTopBar(
            now: DateTime(2026, 5, 2),
            isManaging: false,
            onSettings: () {},
            onDone: () {},
          ),
        ),
      );
      expect(find.byType(DaysLeftLabel), findsOneWidget);
      expect(find.byType(SettingsGearButton), findsOneWidget);
      expect(find.byType(DonePillButton), findsNothing);
    });

    testWidgets('shows Done pill instead of gear in manage mode §3.6', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          HomeTopBar(
            now: DateTime(2026, 5, 2),
            isManaging: true,
            onSettings: () {},
            onDone: () {},
          ),
        ),
      );
      expect(find.byType(DonePillButton), findsOneWidget);
      expect(find.byType(SettingsGearButton), findsNothing);
    });

    testWidgets('tapping settings gear fires onSettings callback §3.7', (
      tester,
    ) async {
      bool fired = false;
      await tester.pumpWidget(
        _wrap(
          HomeTopBar(
            now: DateTime(2026, 5, 2),
            isManaging: false,
            onSettings: () => fired = true,
            onDone: () {},
          ),
        ),
      );
      await tester.tap(find.byType(SettingsGearButton));
      expect(fired, isTrue);
    });

    testWidgets('tapping Done pill fires onDone callback §3.6', (tester) async {
      bool fired = false;
      await tester.pumpWidget(
        _wrap(
          HomeTopBar(
            now: DateTime(2026, 5, 2),
            isManaging: true,
            onSettings: () {},
            onDone: () => fired = true,
          ),
        ),
      );
      await tester.tap(find.byType(DonePillButton));
      expect(fired, isTrue);
    });
  });

  group('DaysLeftLabel §3.1', () {
    testWidgets('shows days remaining in May', (tester) async {
      // May 2 → 29 days left
      await tester.pumpWidget(_wrap(DaysLeftLabel(now: DateTime(2026, 5, 2))));
      expect(find.textContaining('29'), findsAtLeastNWidgets(1));
    });
  });
}
