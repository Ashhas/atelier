/// The user-selectable typeface for goal titles and other content text.
///
/// Display titles (month name, screen titles, brand) always stay on Fraunces
/// italic regardless of this choice — only the goal-text path is affected.
///
/// `plex` is the default: the design iteration landed on IBM Plex Sans for
/// readability on small screens, closer to NOS / Maison Neue than Inter.
enum ContentFont {
  plex,
  manrope,
  inter,
  fraunces;

  /// Italic styling only makes sense for the serif option; sans content
  /// stays upright (italic Inter / Plex / Manrope reads like a bug).
  bool get isItalic => this == ContentFont.fraunces;
}
