import 'package:atelier/data/repositories/prefs_settings_repository.dart';
import 'package:atelier/domain/models/enums/pocket_year_line_mode.dart';
import 'package:atelier/presentation/features/settings/state/settings_cubit.dart';
import 'package:atelier/presentation/features/settings/widgets/pocket_year_line_mode_selector.dart';
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

Widget _wrap(SettingsCubit cubit) => MaterialApp(
  theme: AtelierTheme.light(),
  home: Scaffold(
    body: BlocProvider<SettingsCubit>.value(
      value: cubit,
      child: const PocketYearLineModeSelector(),
    ),
  ),
);

void main() {
  group('PocketYearLineModeSelector', () {
    testWidgets('renders YEAR GOAL LINES label and all three options', (
      tester,
    ) async {
      final cubit = await _makeCubit();
      await tester.pumpWidget(_wrap(cubit));
      await tester.pump();
      expect(find.text('YEAR GOAL LINES'), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.text('FULL'), findsOneWidget);
    });

    testWidgets('tapping FULL sets PocketYearLineMode.full on cubit', (
      tester,
    ) async {
      final cubit = await _makeCubit();
      await tester.pumpWidget(_wrap(cubit));
      await tester.pump();
      await tester.tap(find.text('FULL'));
      await tester.pumpAndSettle();
      expect(cubit.state.settings.pocketYearLineMode, PocketYearLineMode.full);
    });

    testWidgets('tapping 2 sets PocketYearLineMode.twoLines on cubit', (
      tester,
    ) async {
      final cubit = await _makeCubit();
      await tester.pumpWidget(_wrap(cubit));
      await tester.pump();
      await tester.tap(find.text('2'));
      await tester.pumpAndSettle();
      expect(
        cubit.state.settings.pocketYearLineMode,
        PocketYearLineMode.twoLines,
      );
    });
  });
}
