import 'package:atelier/domain/models/enums/content_font.dart';
import 'package:atelier/presentation/common/segmented/segmented.dart';
import 'package:atelier/presentation/common/segmented/segmented_option.dart';
import 'package:atelier/presentation/features/settings/state/settings_cubit.dart';
import 'package:atelier/presentation/features/settings/state/settings_state.dart';
import 'package:atelier/theme/atelier_spacing.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:atelier/theme/atelier_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Settings row: content-font Plex / Manrope / Inter / Serif segmented control.
///
/// Reads current [ContentFont] from [SettingsCubit]; on change calls
/// [SettingsCubit.setContentFont].
///
/// Prototype copy under the picker:
///   "Plex = Reddit's app font. Manrope ≈ NOS feel (closest free match for
///    Maison Neue). Inter = current Flutter app. Serif = original italic look."
class ContentFontSelector extends StatelessWidget {
  const ContentFontSelector({super.key});

  static const _options = [
    SegmentedOptionData<ContentFont>(value: ContentFont.plex, label: 'PLEX'),
    SegmentedOptionData<ContentFont>(
      value: ContentFont.manrope,
      label: 'MANROPE',
    ),
    SegmentedOptionData<ContentFont>(value: ContentFont.inter, label: 'INTER'),
    SegmentedOptionData<ContentFont>(
      value: ContentFont.fraunces,
      label: 'SERIF',
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
              'CONTENT FONT',
              style: AtelierTypography.monoEyebrow.copyWith(color: c.mute),
            ),
            const SizedBox(height: AtelierSpacing.base),
            Segmented<ContentFont>(
              value: state.settings.contentFont,
              options: _options,
              onChanged: (font) =>
                  context.read<SettingsCubit>().setContentFont(font),
            ),
            const SizedBox(height: AtelierSpacing.xs + 2),
            Text(
              "Plex = Reddit's app font. Manrope ≈ NOS feel "
              '(closest free match for Maison Neue). '
              'Inter = current Flutter app. Serif = original italic look.',
              style: AtelierTypography.sansBody.copyWith(
                color: c.mute,
                fontSize: 11,
                height: 1.45,
              ),
            ),
          ],
        );
      },
    );
  }
}
