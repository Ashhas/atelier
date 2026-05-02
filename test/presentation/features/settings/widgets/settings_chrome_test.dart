import 'package:atelier/presentation/features/settings/widgets/settings_backdrop.dart';
import 'package:atelier/presentation/features/settings/widgets/settings_handle.dart';
import 'package:atelier/presentation/features/settings/widgets/settings_header.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) => MaterialApp(
  theme: AtelierTheme.light(),
  home: Scaffold(body: child),
);

void main() {
  group('SettingsHandle §3.7', () {
    testWidgets('renders without error in light theme', (tester) async {
      await tester.pumpWidget(_wrap(const SettingsHandle()));
      expect(find.byType(SettingsHandle), findsOneWidget);
    });
  });

  group('SettingsBackdrop §3.7', () {
    testWidgets('renders without error in light theme', (tester) async {
      await tester.pumpWidget(_wrap(SettingsBackdrop(onDismiss: () {})));
      expect(find.byType(SettingsBackdrop), findsOneWidget);
    });

    testWidgets('tap fires onDismiss callback', (tester) async {
      var dismissed = false;
      await tester.pumpWidget(
        _wrap(SettingsBackdrop(onDismiss: () => dismissed = true)),
      );
      await tester.tap(find.byType(SettingsBackdrop));
      expect(dismissed, isTrue);
    });
  });

  group('SettingsHeader §3.7', () {
    testWidgets('renders "Settings" title in light theme', (tester) async {
      await tester.pumpWidget(_wrap(SettingsHeader(onClose: () {})));
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('tap CLOSE fires onClose callback', (tester) async {
      var closed = false;
      await tester.pumpWidget(
        _wrap(SettingsHeader(onClose: () => closed = true)),
      );
      await tester.tap(find.text('CLOSE'));
      expect(closed, isTrue);
    });
  });
}
