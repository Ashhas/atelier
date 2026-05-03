import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';

/// TextStyle tokens for the design system.
///
/// Call sites: `Text('label', style: AtelierTypography.monoEyebrow.copyWith(color: c.mute))`.
/// Per-call-site variation (color, occasional size/height) goes through `.copyWith()`.
///
/// Tokens are cached as `static final` so each [GoogleFonts] call happens
/// once per token rather than on every read. `.copyWith()` always returns a
/// new style, so call sites still get fresh instances when they vary.
class AtelierTypography {
  const AtelierTypography._();

  // ── Mono (JetBrains Mono — small caps labels, eyebrows, micro labels) ──
  static final TextStyle monoMicro = GoogleFonts.jetBrainsMono(
    fontSize: 8.5,
    letterSpacing: 1.2,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle monoEyebrow = GoogleFonts.jetBrainsMono(
    fontSize: 9,
    letterSpacing: 1.8,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle monoLabel = GoogleFonts.jetBrainsMono(
    fontSize: 10,
    letterSpacing: 1.4,
    fontWeight: FontWeight.w600,
  );

  // ── Serif (Fraunces italic — display titles, goal titles, banner content) ──
  static final TextStyle serifDisplay = GoogleFonts.fraunces(
    fontSize: 24,
    fontStyle: FontStyle.italic,
    letterSpacing: -0.5,
    fontWeight: FontWeight.w400,
  );

  static final TextStyle serifTitle = GoogleFonts.fraunces(
    fontSize: 17,
    fontStyle: FontStyle.italic,
    letterSpacing: -0.3,
    fontWeight: FontWeight.w400,
  );

  static final TextStyle serifBody = GoogleFonts.fraunces(
    fontSize: 12.5,
    fontStyle: FontStyle.italic,
    letterSpacing: -0.2,
    fontWeight: FontWeight.w400,
  );

  // ── Goal-text variants (Inter) ──
  // The …Upright names are kept for backwards compatibility with the
  // 6 widget call sites that already reference them. They were originally
  // Fraunces upright; the user found that too thematic for content text,
  // so they now resolve to Inter — the same family used for sansBody /
  // sansLabel below. Renaming the tokens would touch 6 widget files for
  // zero behaviour gain.
  static final TextStyle serifDisplayUpright = GoogleFonts.inter(
    fontSize: 24,
    letterSpacing: -0.5,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle serifTitleUpright = GoogleFonts.inter(
    fontSize: 17,
    letterSpacing: -0.3,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle serifBodyUpright = GoogleFonts.inter(
    fontSize: 12.5,
    letterSpacing: -0.2,
    fontWeight: FontWeight.w400,
  );

  // ── Sans (Inter — body copy, settings labels) ──
  static final TextStyle sansBody = GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w400,
  );

  static final TextStyle sansLabel = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );
}
