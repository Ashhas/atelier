import 'package:atelier/domain/models/enums/font_scale.dart';
import 'package:atelier/domain/models/enums/pocket_year_line_mode.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AppSettings extends Equatable {
  const AppSettings({
    this.themeMode = ThemeMode.light,
    this.fontScale = FontScale.medium,
    this.pocketYearLineMode = PocketYearLineMode.oneLine,
  });

  final ThemeMode themeMode;
  final FontScale fontScale;
  final PocketYearLineMode pocketYearLineMode;

  AppSettings copyWith({
    ThemeMode? themeMode,
    FontScale? fontScale,
    PocketYearLineMode? pocketYearLineMode,
  }) => AppSettings(
    themeMode: themeMode ?? this.themeMode,
    fontScale: fontScale ?? this.fontScale,
    pocketYearLineMode: pocketYearLineMode ?? this.pocketYearLineMode,
  );

  @override
  List<Object?> get props => [themeMode, fontScale, pocketYearLineMode];
}
