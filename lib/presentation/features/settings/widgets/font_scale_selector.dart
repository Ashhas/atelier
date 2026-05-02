import 'package:atelier/domain/models/enums/font_scale.dart';
import 'package:atelier/presentation/common/segmented/segmented.dart';
import 'package:atelier/presentation/common/segmented/segmented_option.dart';
import 'package:atelier/presentation/features/settings/state/settings_cubit.dart';
import 'package:atelier/presentation/features/settings/state/settings_state.dart';
import 'package:atelier/theme/atelier_spacing.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:atelier/theme/atelier_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Settings row: font scale Small / Medium / Large segmented control.
///
/// Reads current [FontScale] from [SettingsCubit]; on change calls
/// [SettingsCubit.setFontScale].
///
/// Prototype: mono eyebrow label "FONT SIZE" above a three-option Segmented.
class FontScaleSelector extends StatelessWidget {
  const FontScaleSelector({super.key});

  static final _options = [
    const SegmentedOptionData<FontScale>(value: FontScale.small, label: 'SMALL'),
    const SegmentedOptionData<FontScale>(
      value: FontScale.medium,
      label: 'MEDIUM',
    ),
    const SegmentedOptionData<FontScale>(value: FontScale.large, label: 'LARGE'),
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
              'FONT SIZE',
              style: AtelierTypography.monoEyebrow.copyWith(color: c.mute),
            ),
            const SizedBox(height: AtelierSpacing.base),
            Segmented<FontScale>(
              value: state.settings.fontScale,
              options: _options,
              onChanged: (scale) =>
                  context.read<SettingsCubit>().setFontScale(scale),
            ),
          ],
        );
      },
    );
  }
}
