import 'dart:math' as math;

import 'package:atelier/domain/models/goal.dart';
import 'package:atelier/domain/models/goal_category.dart';
import 'package:atelier/domain/models/year_goal.dart';
import 'package:atelier/presentation/features/home/widgets/pocket/pocket_dashed_border.dart';
import 'package:atelier/presentation/features/home/widgets/pocket/pocket_empty_state.dart';
import 'package:atelier/presentation/features/home/widgets/pocket/pocket_goals_preview.dart';
import 'package:atelier/presentation/features/home/widgets/pocket/pocket_header.dart';
import 'package:atelier/presentation/features/home/widgets/pocket/pocket_remove_badge.dart';
import 'package:atelier/presentation/features/home/widgets/pocket/pocket_year_preview.dart';
import 'package:atelier/theme/atelier_spacing.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:flutter/material.dart';

/// A pocket card on the home grid.
///
/// Renders the category name, year-goal preview, and up to 3 month goals.
/// In manage mode shows a × badge and animates with a subtle wiggle.
/// Long-press (≥450ms) fires [onLongPress] to enter manage mode.
///
/// Prototype: background pocket, border 1px rule, borderRadius 14,
/// padding 10, minHeight 130, gap 6 between sections.
class Pocket extends StatefulWidget {
  const Pocket({
    super.key,
    required this.category,
    required this.yearGoalCount,
    required this.goalsPreview,
    required this.isManaging,
    required this.onTap,
    required this.onRemove,
    required this.onLongPress,
    this.expandedYearGoals = const [],
    this.collapsedYearCount = 0,
  });

  final GoalCategory category;
  final int yearGoalCount;
  final List<Goal> goalsPreview;
  final bool isManaging;
  final VoidCallback onTap;
  final VoidCallback onRemove;
  final VoidCallback onLongPress;
  final List<YearGoal> expandedYearGoals;
  final int collapsedYearCount;

  @override
  State<Pocket> createState() => _PocketState();
}

class _PocketState extends State<Pocket> with SingleTickerProviderStateMixin {
  late final AnimationController _wiggle;
  late final Animation<double> _wiggleAngle;

  @override
  void initState() {
    super.initState();
    _wiggle = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _wiggleAngle = Tween<double>(
      // ±0.5 degrees in radians.
      begin: -0.5 * math.pi / 180,
      end: 0.5 * math.pi / 180,
    ).animate(_wiggle);

    if (widget.isManaging) _startWiggle();
  }

  @override
  void didUpdateWidget(Pocket old) {
    super.didUpdateWidget(old);
    if (widget.isManaging && !old.isManaging) {
      _startWiggle();
    } else if (!widget.isManaging && old.isManaging) {
      _wiggle.stop();
      _wiggle.value = 0;
    }
  }

  void _startWiggle() {
    _wiggle.repeat(reverse: true);
  }

  @override
  void dispose() {
    _wiggle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = AtelierTheme.paletteOf(context);
    final isEmpty = widget.goalsPreview.isEmpty;
    final isAddSlot = widget.category.isAddSlot;

    return GestureDetector(
      onTap: widget.isManaging ? null : widget.onTap,
      onLongPress: widget.isManaging ? null : widget.onLongPress,
      child: AnimatedBuilder(
        animation: _wiggleAngle,
        builder: (context, child) => Transform.rotate(
          angle: widget.isManaging ? _wiggleAngle.value : 0,
          child: child,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Add-slot pocket gets a dashed border + transparent fill so it
            // reads as "tap to add" rather than "real content"; everything
            // else uses the normal solid border + pocket fill.
            if (isAddSlot)
              PocketDashedBorder(
                color: c.rule,
                radius: AtelierRadii.x2l,
                child: Container(
                  constraints: const BoxConstraints(minHeight: 130),
                  padding: const EdgeInsets.all(AtelierSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      PocketHeader(
                        // Add-slot is a UI affordance, not user data —
                        // display "NEW" regardless of the stored name so
                        // existing installs (which persist "Open") and
                        // fresh installs read the same.
                        name: isAddSlot ? 'New' : widget.category.name,
                        goalCount: widget.goalsPreview.length,
                      ),
                      PocketYearPreview(
                        yearGoalCount: widget.yearGoalCount,
                        expandedYearGoals: widget.expandedYearGoals,
                        collapsedCount: widget.collapsedYearCount,
                      ),
                      const SizedBox(height: AtelierSpacing.md),
                      if (isEmpty)
                        PocketEmptyState(isAddSlot: isAddSlot)
                      else
                        PocketGoalsPreview(goals: widget.goalsPreview),
                    ],
                  ),
                ),
              )
            else
              Container(
                constraints: const BoxConstraints(minHeight: 130),
                decoration: BoxDecoration(
                  color: c.pocket,
                  border: Border.all(color: c.rule),
                  borderRadius: BorderRadius.circular(AtelierRadii.x2l),
                ),
                padding: const EdgeInsets.all(AtelierSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    PocketHeader(
                      name: isAddSlot ? 'New' : widget.category.name,
                      goalCount: widget.goalsPreview.length,
                    ),
                    PocketYearPreview(
                      yearGoalCount: widget.yearGoalCount,
                      expandedYearGoals: widget.expandedYearGoals,
                      collapsedCount: widget.collapsedYearCount,
                    ),
                    const SizedBox(height: AtelierSpacing.md),
                    if (isEmpty)
                      PocketEmptyState(isAddSlot: isAddSlot)
                    else
                      PocketGoalsPreview(goals: widget.goalsPreview),
                  ],
                ),
              ),
            // × remove badge at top-left in manage mode
            if (widget.isManaging && !isAddSlot)
              Positioned(
                top: -6,
                left: -6,
                child: PocketRemoveBadge(onTap: widget.onRemove),
              ),
          ],
        ),
      ),
    );
  }
}
