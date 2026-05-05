import 'package:atelier/data/repositories/prefs_settings_repository.dart';
import 'package:atelier/presentation/features/settings/settings_sheet.dart';
import 'package:atelier/presentation/features/settings/state/settings_cubit.dart';
import 'package:atelier/presentation/features/settings/widgets/font_scale_selector.dart';
import 'package:atelier/presentation/features/settings/widgets/reset_data_button.dart';
import 'package:atelier/presentation/features/settings/widgets/reset_data_confirm.dart';
import 'package:atelier/presentation/features/settings/widgets/settings_handle.dart';
import 'package:atelier/presentation/features/settings/widgets/settings_header.dart';
import 'package:atelier/presentation/features/settings/widgets/theme_selector.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<SettingsCubit> _makeCubit() async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  final repo = PrefsSettingsRepository(prefs);
  final cubit = SettingsCubit(repo);
  await cubit.load();
  return cubit;
}

Widget _wrap({required SettingsCubit cubit, VoidCallback? onReset}) =>
    MaterialApp(
      theme: AtelierTheme.light(),
      home: Scaffold(
        body: BlocProvider<SettingsCubit>.value(
          value: cubit,
          child: SettingsSheet(onReset: onReset ?? () {}),
        ),
      ),
    );

void main() {
  group('SettingsSheet §3.7', () {
    testWidgets('renders all child widgets', (tester) async {
      final cubit = await _makeCubit();
      await tester.pumpWidget(_wrap(cubit: cubit));
      await tester.pump();
      expect(find.byType(SettingsHandle), findsOneWidget);
      expect(find.byType(SettingsHeader), findsOneWidget);
      expect(find.byType(ThemeSelector), findsOneWidget);
      expect(find.byType(FontScaleSelector), findsOneWidget);
      expect(find.byType(ResetDataButton), findsOneWidget);
    });

    testWidgets('tapping Reset all data shows ResetDataConfirm', (
      tester,
    ) async {
      final cubit = await _makeCubit();
      await tester.pumpWidget(_wrap(cubit: cubit));
      await tester.pump();
      expect(find.byType(ResetDataConfirm), findsNothing);
      await tester.tap(find.byType(ResetDataButton));
      await tester.pumpAndSettle();
      expect(find.byType(ResetDataConfirm), findsOneWidget);
      expect(find.byType(ResetDataButton), findsNothing);
    });

    testWidgets('tapping CANCEL in confirm reverts to ResetDataButton', (
      tester,
    ) async {
      final cubit = await _makeCubit();
      await tester.pumpWidget(_wrap(cubit: cubit));
      await tester.pump();
      await tester.tap(find.byType(ResetDataButton));
      await tester.pumpAndSettle();
      expect(find.byType(ResetDataConfirm), findsOneWidget);
      await tester.tap(find.text('CANCEL'));
      await tester.pumpAndSettle();
      expect(find.byType(ResetDataButton), findsOneWidget);
      expect(find.byType(ResetDataConfirm), findsNothing);
    });

    testWidgets('tapping RESET fires onReset callback', (tester) async {
      var resetFired = false;
      final cubit = await _makeCubit();
      await tester.pumpWidget(
        _wrap(cubit: cubit, onReset: () => resetFired = true),
      );
      await tester.pump();
      await tester.tap(find.byType(ResetDataButton));
      await tester.pumpAndSettle();
      await tester.tap(find.text('RESET'));
      await tester.pumpAndSettle();
      expect(resetFired, isTrue);
    });
  });
}
