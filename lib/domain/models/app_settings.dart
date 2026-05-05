import 'package:atelier/domain/models/enums/content_font.dart';
import 'package:atelier/domain/models/enums/font_scale.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AppSettings extends Equatable {
  const AppSettings({
    this.themeMode = ThemeMode.light,
    this.fontScale = FontScale.medium,
    this.contentFont = ContentFont.plex,
  });

  final ThemeMode themeMode;
  final FontScale fontScale;
  final ContentFont contentFont;

  AppSettings copyWith({
    ThemeMode? themeMode,
    FontScale? fontScale,
    ContentFont? contentFont,
  }) => AppSettings(
    themeMode: themeMode ?? this.themeMode,
    fontScale: fontScale ?? this.fontScale,
    contentFont: contentFont ?? this.contentFont,
  );

  @override
  List<Object?> get props => [themeMode, fontScale, contentFont];
}
