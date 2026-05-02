import 'package:flutter/painting.dart';
import 'package:meta/meta.dart';

@immutable
class AtelierPalette {
  const AtelierPalette({
    required this.bg,
    required this.ink,
    required this.sub,
    required this.mute,
    required this.rule,
    required this.ruleHi,
    required this.accent,
    required this.chip,
    required this.pocket,
    required this.surface,
    required this.starBg,
    required this.starBorder,
    required this.starInk,
    required this.yearBg,
    required this.yearInk,
  });

  final Color bg;
  final Color ink;
  final Color sub;
  final Color mute;
  final Color rule;
  final Color ruleHi;
  final Color accent;
  final Color chip;
  final Color pocket;
  final Color surface;
  final Color starBg;
  final Color starBorder;
  final Color starInk;
  final Color yearBg;
  final Color yearInk;
}
