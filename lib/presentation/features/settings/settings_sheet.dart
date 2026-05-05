import 'package:atelier/presentation/features/settings/widgets/content_font_selector.dart';
import 'package:atelier/presentation/features/settings/widgets/font_scale_selector.dart';
import 'package:atelier/presentation/features/settings/widgets/reset_data_button.dart';
import 'package:atelier/presentation/features/settings/widgets/reset_data_confirm.dart';
import 'package:atelier/presentation/features/settings/widgets/settings_handle.dart';
import 'package:atelier/presentation/features/settings/widgets/settings_header.dart';
import 'package:atelier/presentation/features/settings/widgets/theme_selector.dart';
import 'package:atelier/theme/atelier_spacing.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:flutter/material.dart';

/// The body widget for the settings modal bottom sheet.
///
/// Composes [SettingsHandle], [SettingsHeader], [ThemeSelector],
/// [FontScaleSelector], and the two-step reset flow
/// ([ResetDataButton] → [ResetDataConfirm]).
///
/// This is the widget passed as `builder:` to `showModalBottomSheet`.
/// The [onReset] callback is wired to [DataResetter] + cubit reloads in
/// [HomeScreen] (Task 8.6).
class SettingsSheet extends StatefulWidget {
  const SettingsSheet({super.key, required this.onReset});

  /// Called when the user confirms the destructive reset action.
  final VoidCallback onReset;

  @override
  State<SettingsSheet> createState() => _SettingsSheetState();
}

class _SettingsSheetState extends State<SettingsSheet> {
  bool _confirmingReset = false;

  @override
  Widget build(BuildContext context) {
    final c = AtelierTheme.paletteOf(context);
    // Bottom inset for the system nav bar (3-button or gesture pill) so the
    // sheet's last row never sits behind it when the app is edge-to-edge.
    final systemNavInset = MediaQuery.viewPaddingOf(context).bottom;
    return Container(
      decoration: BoxDecoration(
        color: c.bg,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AtelierRadii.sheet), // 22
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x2E000000),
            blurRadius: 30,
            offset: Offset(0, -8),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(
        AtelierSpacing.x3l, // 22 left
        AtelierSpacing.base + AtelierSpacing.sm, // 12 top
        AtelierSpacing.x3l, // 22 right
        AtelierSpacing.x4l + systemNavInset, // 28 + nav bar height
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SettingsHandle(),
          const SizedBox(height: AtelierSpacing.x3l), // 22
          SettingsHeader(onClose: () => Navigator.of(context).pop()),
          const SizedBox(height: AtelierSpacing.x3l), // 22
          const ThemeSelector(),
          const SizedBox(height: AtelierSpacing.x3l), // 22
          const FontScaleSelector(),
          const SizedBox(height: AtelierSpacing.x3l), // 22
          const ContentFontSelector(),
          const SizedBox(height: AtelierSpacing.x3l), // 22
          // Divider
          Container(height: 1, color: c.rule),
          const SizedBox(height: AtelierSpacing.x3l), // 22
          // Two-step reset
          if (_confirmingReset)
            ResetDataConfirm(
              onReset: widget.onReset,
              onCancel: () => setState(() => _confirmingReset = false),
            )
          else
            ResetDataButton(
              onTap: () => setState(() => _confirmingReset = true),
            ),
        ],
      ),
    );
  }
}
