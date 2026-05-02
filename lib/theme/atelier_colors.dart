import 'package:atelier/theme/atelier_palette.dart';
import 'package:flutter/painting.dart';

class AtelierColors {
  const AtelierColors._();

  static const AtelierPalette light = AtelierPalette(
    bg: Color(0xFFFFFFFF),
    ink: Color(0xFF0A0A0A),
    sub: Color(0xFF525252),
    mute: Color(0xFFA3A3A3),
    rule: Color(0xFFEDEDED),
    ruleHi: Color(0xFF0A0A0A),
    accent: Color(0xFF0A0A0A),
    chip: Color(0xFFFAFAFA),
    pocket: Color(0xFFFFFFFF),
    surface: Color(0xFFFAFAFA),
    starBg: Color(0xFFEDEDED),
    starBorder: Color(0xFFDCDCDC),
    starInk: Color(0xFF0A0A0A),
    yearBg: Color(0xFFF5F5F2),
    yearInk: Color(0xFF0A0A0A),
    error: Color(0xFFB91C1C), // deeper red for contrast on light bg
  );

  static const AtelierPalette dark = AtelierPalette(
    bg: Color(0xFF121212),
    ink: Color(0xFFFFFFFF),
    sub: Color(0xFFA7A7A7),
    mute: Color(0xFF727272),
    rule: Color(0xFF2A2A2A),
    ruleHi: Color(0xFFFFFFFF),
    accent: Color(0xFF1ED760),
    chip: Color(0xFF1F1F1F),
    pocket: Color(0xFF181818),
    surface: Color(0xFF181818),
    starBg: Color(0xFF282828),
    starBorder: Color(0xFF3E3E3E),
    starInk: Color(0xFFFFFFFF),
    yearBg: Color(0xFF181818),
    yearInk: Color(0xFFFFFFFF),
    error: Color(0xFFC54545), // lighter red for contrast on dark bg
  );
}
