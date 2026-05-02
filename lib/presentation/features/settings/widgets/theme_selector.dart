import 'package:atelier/presentation/common/segmented/segmented.dart';
import 'package:atelier/presentation/common/segmented/segmented_option.dart';
import 'package:atelier/presentation/features/settings/state/settings_cubit.dart';
import 'package:atelier/presentation/features/settings/state/settings_state.dart';
import 'package:atelier/theme/atelier_spacing.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:atelier/theme/atelier_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Settings row: theme Light / Dark segmented control.
///
/// Reads current [ThemeMode] from [SettingsCubit]; on change calls
/// [SettingsCubit.setTheme].
///
/// Prototype: mono eyebrow label "THEME" above a two-option Segmented.
class ThemeSelector extends StatelessWidget {
  const ThemeSelector({super.key});

  static final _options = [
    const SegmentedOptionData<ThemeMode>(value: ThemeMode.light, label: 'LIGHT'),
    const SegmentedOptionData<ThemeMode>(value: ThemeMode.dark, label: 'DARK'),
  ];

  @override
  Widget build(BuildContext context) {
    final c = AtelierTheme.paletteOf(context);
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'THEME',
              style: AtelierTypography.monoEyebrow.copyWith(color: c.mute),
            ),
            const SizedBox(height: AtelierSpacing.base),
            Segmented<ThemeMode>(
              value: state.settings.themeMode,
              options: _options,
              onChanged: (mode) => context.read<SettingsCubit>().setTheme(mode),
            ),
          ],
        );
      },
    );
  }
}
