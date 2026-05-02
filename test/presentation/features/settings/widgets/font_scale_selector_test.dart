import 'package:atelier/data/repositories/prefs_settings_repository.dart';
import 'package:atelier/domain/models/enums/font_scale.dart';
import 'package:atelier/presentation/features/settings/state/settings_cubit.dart';
import 'package:atelier/presentation/features/settings/widgets/font_scale_selector.dart';
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
      child: const FontScaleSelector(),
    ),
  ),
);

void main() {
  group('FontScaleSelector §3.7', () {
    testWidgets('renders FONT SIZE label and all three options', (tester) async {
      final cubit = await _makeCubit();
      await tester.pumpWidget(_wrap(cubit));
      await tester.pump();
      expect(find.text('FONT SIZE'), findsOneWidget);
      expect(find.text('SMALL'), findsOneWidget);
      expect(find.text('MEDIUM'), findsOneWidget);
      expect(find.text('LARGE'), findsOneWidget);
    });

    testWidgets('tapping LARGE sets FontScale.large on cubit', (tester) async {
      final cubit = await _makeCubit();
      await tester.pumpWidget(_wrap(cubit));
      await tester.pump();
      await tester.tap(find.text('LARGE'));
      await tester.pumpAndSettle();
      expect(cubit.state.settings.fontScale, FontScale.large);
    });

    testWidgets('tapping SMALL sets FontScale.small on cubit', (tester) async {
      final cubit = await _makeCubit();
      await tester.pumpWidget(_wrap(cubit));
      await tester.pump();
      await tester.tap(find.text('SMALL'));
      await tester.pumpAndSettle();
      expect(cubit.state.settings.fontScale, FontScale.small);
    });
  });
}
