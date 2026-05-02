import 'package:atelier/data/repositories/prefs_settings_repository.dart';
import 'package:atelier/presentation/features/settings/state/settings_cubit.dart';
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

Widget _wrap(SettingsCubit cubit) => MaterialApp(
  theme: AtelierTheme.light(),
  home: Scaffold(
    body: BlocProvider<SettingsCubit>.value(
      value: cubit,
      child: const ThemeSelector(),
    ),
  ),
);

void main() {
  group('ThemeSelector §3.7', () {
    testWidgets('renders THEME label and both options', (tester) async {
      final cubit = await _makeCubit();
      await tester.pumpWidget(_wrap(cubit));
      await tester.pump();
      expect(find.text('THEME'), findsOneWidget);
      expect(find.text('LIGHT'), findsOneWidget);
      expect(find.text('DARK'), findsOneWidget);
    });

    testWidgets('tapping DARK sets ThemeMode.dark on cubit', (tester) async {
      final cubit = await _makeCubit();
      await tester.pumpWidget(_wrap(cubit));
      await tester.pump();
      await tester.tap(find.text('DARK'));
      await tester.pumpAndSettle();
      expect(cubit.state.settings.themeMode, ThemeMode.dark);
    });

    testWidgets('tapping LIGHT keeps ThemeMode.light on cubit', (tester) async {
      final cubit = await _makeCubit();
      await tester.pumpWidget(_wrap(cubit));
      await tester.pump();
      await tester.tap(find.text('LIGHT'));
      await tester.pumpAndSettle();
      expect(cubit.state.settings.themeMode, ThemeMode.light);
    });
  });
}
