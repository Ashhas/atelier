import 'package:atelier/data/repositories/prefs_settings_repository.dart';
import 'package:atelier/domain/models/enums/content_font.dart';
import 'package:atelier/presentation/features/settings/state/settings_cubit.dart';
import 'package:atelier/presentation/features/settings/widgets/content_font_selector.dart';
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
      child: const ContentFontSelector(),
    ),
  ),
);

void main() {
  group('ContentFontSelector', () {
    testWidgets('renders CONTENT FONT label and all four options', (
      tester,
    ) async {
      final cubit = await _makeCubit();
      await tester.pumpWidget(_wrap(cubit));
      await tester.pump();
      expect(find.text('CONTENT FONT'), findsOneWidget);
      expect(find.text('PLEX'), findsOneWidget);
      expect(find.text('MANROPE'), findsOneWidget);
      expect(find.text('INTER'), findsOneWidget);
      expect(find.text('SERIF'), findsOneWidget);
    });

    testWidgets('tapping SERIF sets ContentFont.fraunces on cubit', (
      tester,
    ) async {
      final cubit = await _makeCubit();
      await tester.pumpWidget(_wrap(cubit));
      await tester.pump();
      await tester.tap(find.text('SERIF'));
      await tester.pumpAndSettle();
      expect(cubit.state.settings.contentFont, ContentFont.fraunces);
    });

    testWidgets('tapping INTER sets ContentFont.inter on cubit', (
      tester,
    ) async {
      final cubit = await _makeCubit();
      await tester.pumpWidget(_wrap(cubit));
      await tester.pump();
      await tester.tap(find.text('INTER'));
      await tester.pumpAndSettle();
      expect(cubit.state.settings.contentFont, ContentFont.inter);
    });
  });
}
