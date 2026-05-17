import 'package:atelier/domain/models/enums/font_scale.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AppSettings extends Equatable {
  const AppSettings({
    this.themeMode = ThemeMode.light,
    this.fontScale = FontScale.medium,
    this.pocketYearLines = 1,
    this.pocketGoalsPreviewCount = 3,
  });

  final ThemeMode themeMode;
  final FontScale fontScale;

  /// Max lines each year-goal title may wrap to in the pocket preview.
  /// `null` means unbounded (the "Full" preset).
  final int? pocketYearLines;

  /// Max monthly goals each pocket card previews before showing "+N more".
  /// `null` means all goals (the "All" preset).
  final int? pocketGoalsPreviewCount;

  AppSettings copyWith({
    ThemeMode? themeMode,
    FontScale? fontScale,
    Object? pocketYearLines = _sentinel,
    Object? pocketGoalsPreviewCount = _sentinel,
  }) => AppSettings(
    themeMode: themeMode ?? this.themeMode,
    fontScale: fontScale ?? this.fontScale,
    pocketYearLines: identical(pocketYearLines, _sentinel)
        ? this.pocketYearLines
        : pocketYearLines as int?,
    pocketGoalsPreviewCount: identical(pocketGoalsPreviewCount, _sentinel)
        ? this.pocketGoalsPreviewCount
        : pocketGoalsPreviewCount as int?,
  );

  @override
  List<Object?> get props => [
    themeMode,
    fontScale,
    pocketYearLines,
    pocketGoalsPreviewCount,
  ];
}

// Sentinel so copyWith can distinguish "not provided" from "explicitly null".
const _sentinel = Object();
