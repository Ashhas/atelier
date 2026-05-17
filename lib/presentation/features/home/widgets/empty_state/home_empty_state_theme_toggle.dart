import 'package:atelier/presentation/features/settings/state/settings_cubit.dart';
import 'package:atelier/presentation/features/settings/state/settings_state.dart';
import 'package:atelier/theme/atelier_spacing.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:atelier/theme/atelier_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// First-launch theme picker shown beneath the home empty state.
///
/// Renders nothing once the user has ever added a goal (the
/// `hasGoalEver` latch on AppSettings). On a fresh install this is
/// the one moment we nudge the user to set the vibe before they
/// commit any content; afterwards, theme is changed via Settings.
///
/// Visual: `THEME` mono eyebrow above a 44×44 round button. The button
/// glyph is the OPPOSITE of the current theme — reads as "tap to switch
/// to that." Switching morphs the glyph (rotate + scale + fade) over
/// ~350ms via AnimatedSwitcher.
class HomeEmptyStateThemeToggle extends StatelessWidget {
  const HomeEmptyStateThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        if (state.settings.hasGoalEver) return const SizedBox.shrink();
        return const _ThemeToggleStack();
      },
    );
  }
}

class _ThemeToggleStack extends StatelessWidget {
  const _ThemeToggleStack();

  @override
  Widget build(BuildContext context) {
    final p = AtelierTheme.paletteOf(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'THEME',
          style: AtelierTypography.monoEyebrow.copyWith(
            color: p.mute,
            letterSpacing: 1.8,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AtelierSpacing.base),
        const _MorphToggleButton(),
      ],
    );
  }
}

class _MorphToggleButton extends StatelessWidget {
  const _MorphToggleButton();

  @override
  Widget build(BuildContext context) {
    final p = AtelierTheme.paletteOf(context);
    final cubit = context.read<SettingsCubit>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Show the OPPOSITE icon — the action, not the current state.
    final icon = isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined;

    return Semantics(
      button: true,
      label: isDark ? 'Switch to light theme' : 'Switch to dark theme',
      child: GestureDetector(
        onTap: () => cubit.setTheme(isDark ? ThemeMode.light : ThemeMode.dark),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: p.surface,
            border: Border.all(color: p.rule),
            borderRadius: BorderRadius.circular(AtelierRadii.pill),
          ),
          alignment: Alignment.center,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            switchInCurve: Curves.easeOutCubic,
            transitionBuilder: (child, animation) {
              // Outgoing children just fade; incoming child rotates + scales
              // + fades in from -60° / 60% scale to its resting state.
              final rotation = Tween<double>(
                begin: -60 / 360,
                end: 0,
              ).animate(animation);
              final scale = Tween<double>(
                begin: 0.6,
                end: 1,
              ).animate(animation);
              return FadeTransition(
                opacity: animation,
                child: RotationTransition(
                  turns: rotation,
                  child: ScaleTransition(scale: scale, child: child),
                ),
              );
            },
            child: Icon(icon, key: ValueKey(icon), size: 20, color: p.ink),
          ),
        ),
      ),
    );
  }
}
