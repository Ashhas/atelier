import 'package:atelier/domain/models/goal.dart';
import 'package:atelier/domain/models/goal_category.dart';
import 'package:atelier/domain/models/year_goal.dart';
import 'package:atelier/presentation/common/segmented/segmented.dart';
import 'package:atelier/presentation/common/segmented/segmented_option.dart';
import 'package:atelier/presentation/features/home/widgets/pocket/pocket.dart';
import 'package:atelier/presentation/features/settings/state/settings_cubit.dart';
import 'package:atelier/presentation/features/settings/state/settings_state.dart';
import 'package:atelier/theme/atelier_spacing.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:atelier/theme/atelier_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Single density picker for the pocket card.
///
/// Three presets (Compact / Standard / Expanded) that each map to a
/// `(pocketYearLines, pocketGoalsPreviewCount)` pair. When the user's
/// current values match a preset, that segment lights up. When they
/// diverge (via the Customize disclosure below), the hint reads
/// `Custom · {lines} · {goals}` and no segment is active.
///
/// Customize reveals two number steppers (1..5 + Full for lines, 1..15
/// + All for goals) so the user can pick any combination.
///
/// A live pocket preview between the segmented control and Customize
/// shows the effect concretely against fixture data, not the user's own
/// goals — the user's data is unbounded in length and would defeat the
/// "watch this change" intent.
class PocketDensitySelector extends StatefulWidget {
  const PocketDensitySelector({super.key});

  @override
  State<PocketDensitySelector> createState() => _PocketDensitySelectorState();
}

class _PocketDensitySelectorState extends State<PocketDensitySelector> {
  bool _customizeOpen = false;

  static const _presets = <_DensityPreset, _DensityValues>{
    _DensityPreset.compact: _DensityValues(lines: 1, count: 3),
    _DensityPreset.standard: _DensityValues(lines: 2, count: 5),
    _DensityPreset.expanded: _DensityValues(lines: null, count: null),
  };

  _DensityPreset? _activePreset(int? lines, int? count) {
    for (final entry in _presets.entries) {
      if (entry.value.lines == lines && entry.value.count == count) {
        return entry.key;
      }
    }
    return null;
  }

  String _hint(int? lines, int? count) {
    final preset = _activePreset(lines, count);
    if (preset != null) {
      return switch (preset) {
        _DensityPreset.compact => '1 LINE · 3 GOALS',
        _DensityPreset.standard => '2 LINES · 5 GOALS',
        _DensityPreset.expanded => 'FULL · ALL GOALS',
      };
    }
    final linesPart = lines == null
        ? 'FULL LINES'
        : '$lines ${lines == 1 ? 'LINE' : 'LINES'}';
    final countPart = count == null
        ? 'ALL GOALS'
        : '$count ${count == 1 ? 'GOAL' : 'GOALS'}';
    return 'CUSTOM · $linesPart · $countPart';
  }

  @override
  Widget build(BuildContext context) {
    final p = AtelierTheme.paletteOf(context);

    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final lines = state.settings.pocketYearLines;
        final count = state.settings.pocketGoalsPreviewCount;
        final preset = _activePreset(lines, count);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'POCKET DENSITY',
              style: AtelierTypography.monoEyebrow.copyWith(color: p.mute),
            ),
            const SizedBox(height: AtelierSpacing.base),
            Segmented<_DensityPreset>(
              value: preset,
              options: const [
                SegmentedOptionData(
                  value: _DensityPreset.compact,
                  label: 'COMPACT',
                ),
                SegmentedOptionData(
                  value: _DensityPreset.standard,
                  label: 'STANDARD',
                ),
                SegmentedOptionData(
                  value: _DensityPreset.expanded,
                  label: 'EXPANDED',
                ),
              ],
              onChanged: (key) {
                final v = _presets[key]!;
                final cubit = context.read<SettingsCubit>();
                cubit.setPocketYearLines(v.lines);
                cubit.setPocketGoalsPreviewCount(v.count);
              },
            ),
            const SizedBox(height: AtelierSpacing.base),
            Text(
              _hint(lines, count),
              style: AtelierTypography.monoMicro.copyWith(
                color: p.sub,
                letterSpacing: 1.4,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AtelierSpacing.lg),
            _DensityPreview(lines: lines, count: count),
            const SizedBox(height: AtelierSpacing.lg),
            _CustomizeToggle(
              open: _customizeOpen,
              onTap: () => setState(() => _customizeOpen = !_customizeOpen),
            ),
            if (_customizeOpen) ...[
              const SizedBox(height: AtelierSpacing.lg),
              _StepperRow(
                label: 'YEAR GOAL LINES',
                hint: 'Each year-goal title may use this many lines.',
                value: lines,
                min: 1,
                max: 5,
                unboundedLabel: 'FULL',
                onChanged: (v) =>
                    context.read<SettingsCubit>().setPocketYearLines(v),
              ),
              const SizedBox(height: AtelierSpacing.lg),
              _StepperRow(
                label: 'GOALS PER POCKET',
                hint: 'How many monthly goals before "+N more".',
                value: count,
                min: 1,
                max: 15,
                unboundedLabel: 'ALL',
                onChanged: (v) =>
                    context.read<SettingsCubit>().setPocketGoalsPreviewCount(v),
              ),
            ],
          ],
        );
      },
    );
  }
}

enum _DensityPreset { compact, standard, expanded }

class _DensityValues {
  const _DensityValues({required this.lines, required this.count});
  final int? lines;
  final int? count;
}

/// Live preview using the real `Pocket` widget against fixed fixture data,
/// so the user sees the setting's effect without their own list overwhelming
/// the preview area.
class _DensityPreview extends StatelessWidget {
  const _DensityPreview({required this.lines, required this.count});

  final int? lines;
  final int? count;

  static const _category = GoalCategory(id: '_preview', name: 'Body', order: 0);

  static final _now = DateTime(2026, 5, 12);

  // Deliberately long titles so the year-line clamp difference is
  // visible: at the 200px preview width these wrap to 3+ lines, which
  // makes Compact (1 line, truncated) vs Standard (2 lines) vs
  // Expanded (Full) read clearly.
  static final _yearGoals = <YearGoal>[
    const YearGoal(
      id: '_preview-y1',
      goalCategoryId: '_preview',
      title: 'Run a sub-22 5K and finish at least one half-marathon this year',
    ),
    const YearGoal(
      id: '_preview-y2',
      goalCategoryId: '_preview',
      title: 'Hit a strict pull-up at bodyweight + 20kg by the end of December',
    ),
  ];

  static final _goals = <Goal>[
    Goal(
      id: '_preview-g1',
      goalCategoryId: '_preview',
      title: 'Sub-25 5K',
      starred: true,
      addedAt: _now,
    ),
    Goal(
      id: '_preview-g2',
      goalCategoryId: '_preview',
      title: 'Strength 3×/wk',
      addedAt: _now,
    ),
    Goal(
      id: '_preview-g3',
      goalCategoryId: '_preview',
      title: 'Long run Saturday',
      addedAt: _now,
    ),
    Goal(
      id: '_preview-g4',
      goalCategoryId: '_preview',
      title: 'Mobility 10 min daily',
      addedAt: _now,
    ),
    Goal(
      id: '_preview-g5',
      goalCategoryId: '_preview',
      title: 'Sleep 7+ hrs, 6 nights/wk',
      addedAt: _now,
    ),
    Goal(
      id: '_preview-g6',
      goalCategoryId: '_preview',
      title: 'Cook dinner 5× per week',
      addedAt: _now,
    ),
  ];

  // Tall enough to comfortably show a Standard (2 lines, 5 goals) preview
  // at natural size. Anything larger (Expanded / lots of lines) will be
  // scaled down by the FittedBox below so the surrounding settings list
  // doesn't jump around as the user dials density up.
  static const double _frameHeight = 280;

  @override
  Widget build(BuildContext context) {
    final p = AtelierTheme.paletteOf(context);
    return Container(
      padding: const EdgeInsets.all(AtelierSpacing.lg),
      decoration: BoxDecoration(
        color: p.surface,
        border: Border.all(color: p.rule),
        borderRadius: BorderRadius.circular(AtelierRadii.lg),
      ),
      child: SizedBox(
        height: _frameHeight,
        child: Center(
          // scaleDown: shrinks the pocket only when it exceeds the frame;
          // smaller previews render at natural size (no upscaling). This
          // keeps the preview block's outer height fixed regardless of
          // density picks, which avoids the surrounding list shifting
          // when the user changes settings.
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.center,
            child: SizedBox(
              width: 200,
              child: _PreviewPocket(
                lines: lines,
                count: count,
                yearGoals: _yearGoals,
                goals: _goals,
                category: _category,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A trimmed-down pocket card driven by overrides — does NOT read from
/// the SettingsCubit. Reuses PocketYearPreview / PocketGoalsPreview via
/// their `*Override` resolvers so the visual stays in sync with what
/// home renders, just smaller and disconnected from real data.
class _PreviewPocket extends StatelessWidget {
  const _PreviewPocket({
    required this.lines,
    required this.count,
    required this.yearGoals,
    required this.goals,
    required this.category,
  });

  final int? lines;
  final int? count;
  final List<YearGoal> yearGoals;
  final List<Goal> goals;
  final GoalCategory category;

  @override
  Widget build(BuildContext context) {
    return Pocket(
      category: category,
      yearGoalCount: yearGoals.length,
      expandedYearGoals: yearGoals,
      goalsPreview: goals,
      isManaging: false,
      onTap: () {},
      onRemove: () {},
      onLongPress: () {},
      yearLinesOverride: () => lines,
      goalsLimitOverride: () => count,
    );
  }
}

class _CustomizeToggle extends StatelessWidget {
  const _CustomizeToggle({required this.open, required this.onTap});

  final bool open;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = AtelierTheme.paletteOf(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AtelierSpacing.xs),
        child: Text(
          open ? '▾  HIDE CUSTOM' : '▸  CUSTOMIZE',
          style: AtelierTypography.monoEyebrow.copyWith(
            color: p.sub,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _StepperRow extends StatelessWidget {
  const _StepperRow({
    required this.label,
    required this.hint,
    required this.value,
    required this.min,
    required this.max,
    required this.unboundedLabel,
    required this.onChanged,
  });

  final String label;
  final String hint;
  final int? value;
  final int min;
  final int max;
  final String unboundedLabel;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    final p = AtelierTheme.paletteOf(context);
    final isUnbounded = value == null;
    final numeric = isUnbounded ? min : value!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: AtelierTypography.monoEyebrow.copyWith(color: p.mute),
        ),
        const SizedBox(height: AtelierSpacing.base),
        Row(
          children: [
            Expanded(
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 150),
                opacity: isUnbounded ? 0.4 : 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: p.surface,
                    border: Border.all(color: p.rule),
                    borderRadius: BorderRadius.circular(AtelierRadii.pill),
                  ),
                  padding: const EdgeInsets.all(AtelierSpacing.xs),
                  child: Row(
                    children: [
                      _StepButton(
                        glyph: '−',
                        onTap: isUnbounded || numeric <= min
                            ? null
                            : () => onChanged(numeric - 1),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            isUnbounded ? '—' : '$numeric',
                            style: AtelierTypography.monoLabel.copyWith(
                              color: p.ink,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      _StepButton(
                        glyph: '+',
                        onTap: isUnbounded || numeric >= max
                            ? null
                            : () => onChanged(numeric + 1),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: AtelierSpacing.base),
            _UnboundedPill(
              label: unboundedLabel,
              active: isUnbounded,
              onTap: () => onChanged(isUnbounded ? min : null),
            ),
          ],
        ),
        const SizedBox(height: AtelierSpacing.sm),
        Text(
          hint,
          style: AtelierTypography.monoMicro.copyWith(
            color: p.sub,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({required this.glyph, required this.onTap});

  final String glyph;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final p = AtelierTheme.paletteOf(context);
    final disabled = onTap == null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: disabled ? Colors.transparent : p.bg,
          borderRadius: BorderRadius.circular(AtelierRadii.pill),
        ),
        child: Text(
          glyph,
          style: AtelierTypography.monoLabel.copyWith(
            color: disabled ? p.mute : p.ink,
            fontWeight: FontWeight.w700,
            fontSize: 16,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class _UnboundedPill extends StatelessWidget {
  const _UnboundedPill({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = AtelierTheme.paletteOf(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AtelierSpacing.xl,
          vertical: AtelierSpacing.base + 2,
        ),
        decoration: BoxDecoration(
          color: active ? p.ink : Colors.transparent,
          border: Border.all(color: active ? p.ink : p.rule),
          borderRadius: BorderRadius.circular(AtelierRadii.pill),
        ),
        child: Text(
          label,
          style: AtelierTypography.monoEyebrow.copyWith(
            color: active ? p.bg : p.sub,
          ),
        ),
      ),
    );
  }
}
