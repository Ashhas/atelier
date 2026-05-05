import 'package:atelier/domain/models/enums/content_font.dart';
import 'package:atelier/presentation/features/settings/state/settings_cubit.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Reads the user-selected content font from [SettingsCubit].
///
/// Goal-text widgets call this once per build to feed
/// `AtelierTypography.serif*Upright(font)`. The whole subtree rebuilds when
/// the cubit emits a new state because `MaterialApp` is wrapped in a
/// `BlocBuilder<SettingsCubit, SettingsState>` at the composition root, so
/// reading via `context.watch` here is not strictly required — `context.read`
/// is enough.
///
/// When the cubit is not in scope (widget tests that exercise a single
/// goal-text widget in isolation), this falls back to [ContentFont.plex] —
/// the production default — so individual widget tests don't have to mount
/// a settings harness just to read goal text.
extension ContentFontContext on BuildContext {
  ContentFont get contentFont {
    try {
      return read<SettingsCubit>().state.settings.contentFont;
    } on ProviderNotFoundException {
      return ContentFont.plex;
    }
  }
}
