import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';

/// TextStyle tokens for the design system.
///
/// Call sites: `Text('label', style: AtelierTypography.monoEyebrow.copyWith(color: c.mute))`.
/// Per-call-site variation (color, occasional size/height) goes through `.copyWith()`.
class AtelierTypography {
  const AtelierTypography._();

  // ── Mono (JetBrains Mono — small caps labels, eyebrows, micro labels) ──
  static TextStyle get monoMicro => GoogleFonts.jetBrainsMono(
    fontSize: 8.5,
    letterSpacing: 1.2,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get monoEyebrow => GoogleFonts.jetBrainsMono(
    fontSize: 9,
    letterSpacing: 1.8,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get monoLabel => GoogleFonts.jetBrainsMono(
    fontSize: 10,
    letterSpacing: 1.4,
    fontWeight: FontWeight.w600,
  );

  // ── Serif (Fraunces italic — display titles, goal titles, banner content) ──
  static TextStyle get serifDisplay => GoogleFonts.fraunces(
    fontSize: 24,
    fontStyle: FontStyle.italic,
    letterSpacing: -0.5,
    fontWeight: FontWeight.w400,
  );

  static TextStyle get serifTitle => GoogleFonts.fraunces(
    fontSize: 17,
    fontStyle: FontStyle.italic,
    letterSpacing: -0.3,
    fontWeight: FontWeight.w400,
  );

  static TextStyle get serifBody => GoogleFonts.fraunces(
    fontSize: 12.5,
    fontStyle: FontStyle.italic,
    letterSpacing: -0.2,
    fontWeight: FontWeight.w400,
  );

  // ── Sans (Inter — body copy, settings labels) ──
  static TextStyle get sansBody =>
      GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w400);

  static TextStyle get sansLabel =>
      GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600);
}
