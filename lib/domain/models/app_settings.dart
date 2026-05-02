import 'package:atelier/domain/models/enums/font_scale.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AppSettings extends Equatable {
  const AppSettings({
    this.themeMode = ThemeMode.light,
    this.fontScale = FontScale.medium,
  });

  final ThemeMode themeMode;
  final FontScale fontScale;

  AppSettings copyWith({ThemeMode? themeMode, FontScale? fontScale}) =>
      AppSettings(
        themeMode: themeMode ?? this.themeMode,
        fontScale: fontScale ?? this.fontScale,
      );

  @override
  List<Object?> get props => [themeMode, fontScale];
}
