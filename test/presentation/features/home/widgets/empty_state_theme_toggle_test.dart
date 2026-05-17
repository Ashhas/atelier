import 'package:atelier/data/repositories/prefs_settings_repository.dart';
import 'package:atelier/presentation/features/home/widgets/empty_state/home_empty_state_theme_toggle.dart';
import 'package:atelier/presentation/features/settings/state/settings_cubit.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<SettingsCubit> _makeCubit({bool hasGoalEver = false}) async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  final repo = PrefsSettingsRepository(prefs);
  final cubit = SettingsCubit(repo);
  await cubit.load();
  if (hasGoalEver) await cubit.markGoalEver();
  return cubit;
}

Widget _wrap(SettingsCubit cubit) => MaterialApp(
  theme: AtelierTheme.light(),
  home: Scaffold(
    body: BlocProvider<SettingsCubit>.value(
      value: cubit,
      child: const HomeEmptyStateThemeToggle(),
    ),
  ),
);

void main() {
  group('HomeEmptyStateThemeToggle', () {
    testWidgets('renders THEME eyebrow + button on first run', (tester) async {
      final cubit = await _makeCubit();
      await tester.pumpWidget(_wrap(cubit));
      await tester.pumpAndSettle();

      expect(find.text('THEME'), findsOneWidget);
      // The button shows the OPPOSITE icon — light theme shows the
      // dark_mode icon ("tap to switch to dark").
      expect(find.byIcon(Icons.dark_mode_outlined), findsOneWidget);
    });

    testWidgets('renders nothing once hasGoalEver is true', (tester) async {
      final cubit = await _makeCubit(hasGoalEver: true);
      await tester.pumpWidget(_wrap(cubit));
      await tester.pumpAndSettle();

      expect(find.text('THEME'), findsNothing);
      expect(find.byIcon(Icons.dark_mode_outlined), findsNothing);
      expect(find.byIcon(Icons.light_mode_outlined), findsNothing);
    });

    testWidgets('tapping the button toggles theme on the cubit', (
      tester,
    ) async {
      final cubit = await _makeCubit();
      await tester.pumpWidget(_wrap(cubit));
      await tester.pumpAndSettle();

      expect(cubit.state.settings.themeMode, ThemeMode.light);
      await tester.tap(find.byIcon(Icons.dark_mode_outlined));
      await tester.pumpAndSettle();
      expect(cubit.state.settings.themeMode, ThemeMode.dark);
    });
  });
}
