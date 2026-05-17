import 'package:atelier/domain/models/enums/font_scale.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AppSettings extends Equatable {
  const AppSettings({
    this.themeMode = ThemeMode.light,
    this.fontScale = FontScale.medium,
    this.pocketYearLines = 1,
    this.pocketGoalsPreviewCount = 3,
    this.hasGoalEver = false,
  });

  final ThemeMode themeMode;
  final FontScale fontScale;

  /// Max lines each year-goal title may wrap to in the pocket preview.
  /// `null` means unbounded (the "Full" preset).
  final int? pocketYearLines;

  /// Max monthly goals each pocket card previews before showing "+N more".
  /// `null` means all goals (the "All" preset).
  final int? pocketGoalsPreviewCount;

  /// First-run latch. Flipped true the first time the user creates ANY
  /// goal (monthly or yearly). Once true, stays true even if the user
  /// later clears back to an empty state — the home empty-state's
  /// theme-toggle moment is intentionally a one-time first-run nudge.
  /// Cleared by Reset all data.
  final bool hasGoalEver;

  AppSettings copyWith({
    ThemeMode? themeMode,
    FontScale? fontScale,
    Object? pocketYearLines = _sentinel,
    Object? pocketGoalsPreviewCount = _sentinel,
    bool? hasGoalEver,
  }) => AppSettings(
    themeMode: themeMode ?? this.themeMode,
    fontScale: fontScale ?? this.fontScale,
    pocketYearLines: identical(pocketYearLines, _sentinel)
        ? this.pocketYearLines
        : pocketYearLines as int?,
    pocketGoalsPreviewCount: identical(pocketGoalsPreviewCount, _sentinel)
        ? this.pocketGoalsPreviewCount
        : pocketGoalsPreviewCount as int?,
    hasGoalEver: hasGoalEver ?? this.hasGoalEver,
  );

  @override
  List<Object?> get props => [
    themeMode,
    fontScale,
    pocketYearLines,
    pocketGoalsPreviewCount,
    hasGoalEver,
  ];
}

// Sentinel so copyWith can distinguish "not provided" from "explicitly null".
const _sentinel = Object();
