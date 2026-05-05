import 'package:atelier/domain/models/enums/content_font.dart';
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
///
/// The goal-text tokens (`serifDisplayUpright`, `serifTitleUpright`,
/// `serifBodyUpright`) are *methods* that take a [ContentFont]: the user
/// can swap between Plex / Manrope / Inter / Fraunces from settings.
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

  // ── Serif (Fraunces italic — display titles, banner content) ──
  // Display tokens are *always* Fraunces italic regardless of the goal-text
  // family choice — month name, screen titles, and the brand wordmark live
  // here.
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

  // ── Goal-text variants (user-selectable family) ──
  // The …Upright names are kept for backwards compatibility with the
  // widget call sites that already reference them. They were originally
  // Fraunces upright; the user found that too thematic for content text,
  // so they now resolve to a user-selected family — Plex (default),
  // Manrope, Inter, or Fraunces (italic). The italic flag is tied to the
  // family because italic Inter / Plex / Manrope reads like a bug.

  static TextStyle serifDisplayUpright(ContentFont font) => _contentFont(font)(
    fontSize: 24,
    letterSpacing: -0.5,
    fontWeight: FontWeight.w500,
    fontStyle: font.isItalic ? FontStyle.italic : FontStyle.normal,
  );

  static TextStyle serifTitleUpright(ContentFont font) => _contentFont(font)(
    fontSize: 17,
    letterSpacing: -0.3,
    fontWeight: FontWeight.w500,
    fontStyle: font.isItalic ? FontStyle.italic : FontStyle.normal,
  );

  static TextStyle serifBodyUpright(ContentFont font) => _contentFont(font)(
    fontSize: 12.5,
    letterSpacing: -0.2,
    fontWeight: FontWeight.w400,
    fontStyle: font.isItalic ? FontStyle.italic : FontStyle.normal,
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

  /// Maps the [ContentFont] to its corresponding `GoogleFonts.*` builder.
  static TextStyle Function({
    TextStyle? textStyle,
    Color? color,
    Color? backgroundColor,
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? letterSpacing,
    double? wordSpacing,
    TextBaseline? textBaseline,
    double? height,
    Locale? locale,
    Paint? foreground,
    Paint? background,
    List<Shadow>? shadows,
    List<FontFeature>? fontFeatures,
    TextDecoration? decoration,
    Color? decorationColor,
    TextDecorationStyle? decorationStyle,
    double? decorationThickness,
  })
  _contentFont(ContentFont font) {
    switch (font) {
      case ContentFont.plex:
        return GoogleFonts.ibmPlexSans;
      case ContentFont.manrope:
        return GoogleFonts.manrope;
      case ContentFont.inter:
        return GoogleFonts.inter;
      case ContentFont.fraunces:
        return GoogleFonts.fraunces;
    }
  }
}
