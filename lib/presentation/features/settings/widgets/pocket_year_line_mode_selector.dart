import 'package:atelier/domain/models/enums/pocket_year_line_mode.dart';
import 'package:atelier/presentation/common/segmented/segmented.dart';
import 'package:atelier/presentation/common/segmented/segmented_option.dart';
import 'package:atelier/presentation/features/settings/state/settings_cubit.dart';
import 'package:atelier/presentation/features/settings/state/settings_state.dart';
import 'package:atelier/theme/atelier_spacing.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:atelier/theme/atelier_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Settings row: how many lines a year-goal title may take in the pocket
/// preview — 1 / 2 / Full.
///
/// Full lets titles wrap to as many lines as they need, which can make
/// individual pockets visibly taller than their siblings. Users opt in.
class PocketYearLineModeSelector extends StatelessWidget {
  const PocketYearLineModeSelector({super.key});

  static final _options = [
    const SegmentedOptionData<PocketYearLineMode>(
      value: PocketYearLineMode.oneLine,
      label: '1',
    ),
    const SegmentedOptionData<PocketYearLineMode>(
      value: PocketYearLineMode.twoLines,
      label: '2',
    ),
    const SegmentedOptionData<PocketYearLineMode>(
      value: PocketYearLineMode.full,
      label: 'FULL',
    ),
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
              'YEAR GOAL LINES',
              style: AtelierTypography.monoEyebrow.copyWith(color: c.mute),
            ),
            const SizedBox(height: AtelierSpacing.base),
            Segmented<PocketYearLineMode>(
              value: state.settings.pocketYearLineMode,
              options: _options,
              onChanged: (mode) =>
                  context.read<SettingsCubit>().setPocketYearLineMode(mode),
            ),
          ],
        );
      },
    );
  }
}
