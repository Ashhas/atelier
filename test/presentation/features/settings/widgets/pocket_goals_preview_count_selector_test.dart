import 'package:atelier/data/repositories/prefs_settings_repository.dart';
import 'package:atelier/domain/models/enums/pocket_goals_preview_count.dart';
import 'package:atelier/presentation/features/settings/state/settings_cubit.dart';
import 'package:atelier/presentation/features/settings/widgets/pocket_goals_preview_count_selector.dart';
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
      child: const PocketGoalsPreviewCountSelector(),
    ),
  ),
);

void main() {
  group('PocketGoalsPreviewCountSelector', () {
    testWidgets('renders GOALS PER POCKET label and all three options', (
      tester,
    ) async {
      final cubit = await _makeCubit();
      await tester.pumpWidget(_wrap(cubit));
      await tester.pump();
      expect(find.text('GOALS PER POCKET'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
      expect(find.text('ALL'), findsOneWidget);
    });

    testWidgets('tapping ALL sets PocketGoalsPreviewCount.all on cubit', (
      tester,
    ) async {
      final cubit = await _makeCubit();
      await tester.pumpWidget(_wrap(cubit));
      await tester.pump();
      await tester.tap(find.text('ALL'));
      await tester.pumpAndSettle();
      expect(
        cubit.state.settings.pocketGoalsPreviewCount,
        PocketGoalsPreviewCount.all,
      );
    });

    testWidgets('tapping 5 sets PocketGoalsPreviewCount.five on cubit', (
      tester,
    ) async {
      final cubit = await _makeCubit();
      await tester.pumpWidget(_wrap(cubit));
      await tester.pump();
      await tester.tap(find.text('5'));
      await tester.pumpAndSettle();
      expect(
        cubit.state.settings.pocketGoalsPreviewCount,
        PocketGoalsPreviewCount.five,
      );
    });
  });
}
