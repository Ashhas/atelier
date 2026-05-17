import 'package:atelier/domain/models/enums/pocket_goals_preview_count.dart';
import 'package:atelier/presentation/common/segmented/segmented.dart';
import 'package:atelier/presentation/common/segmented/segmented_option.dart';
import 'package:atelier/presentation/features/settings/state/settings_cubit.dart';
import 'package:atelier/presentation/features/settings/state/settings_state.dart';
import 'package:atelier/theme/atelier_spacing.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:atelier/theme/atelier_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Settings row: how many monthly goals a pocket card may preview — 3 / 5 /
/// ALL. ALL grows the pocket to fit every goal, which can produce a ragged
/// grid; users opt in.
class PocketGoalsPreviewCountSelector extends StatelessWidget {
  const PocketGoalsPreviewCountSelector({super.key});

  static final _options = [
    const SegmentedOptionData<PocketGoalsPreviewCount>(
      value: PocketGoalsPreviewCount.three,
      label: '3',
    ),
    const SegmentedOptionData<PocketGoalsPreviewCount>(
      value: PocketGoalsPreviewCount.five,
      label: '5',
    ),
    const SegmentedOptionData<PocketGoalsPreviewCount>(
      value: PocketGoalsPreviewCount.all,
      label: 'ALL',
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
              'GOALS PER POCKET',
              style: AtelierTypography.monoEyebrow.copyWith(color: c.mute),
            ),
            const SizedBox(height: AtelierSpacing.base),
            Segmented<PocketGoalsPreviewCount>(
              value: state.settings.pocketGoalsPreviewCount,
              options: _options,
              onChanged: (count) => context
                  .read<SettingsCubit>()
                  .setPocketGoalsPreviewCount(count),
            ),
          ],
        );
      },
    );
  }
}
