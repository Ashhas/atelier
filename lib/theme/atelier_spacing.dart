/// T-shirt-scale spacing tokens. For values not in the scale, compose with
/// sums of base tokens (e.g. `AtelierSpacing.base + AtelierSpacing.sm` for 12).
class AtelierSpacing {
  const AtelierSpacing._();

  static const double xs = 2;
  static const double sm = 4;
  static const double md = 6;
  static const double base = 8;
  static const double lg = 10;
  static const double xl = 14;
  static const double x2l = 16;
  static const double x3l = 22;
  static const double x4l = 28;
}

/// Corner radii tokens. Pair with [AtelierSpacing] in [theme/atelier_spacing.dart].
class AtelierRadii {
  const AtelierRadii._();

  static const double sm = 6;
  static const double md = 8;
  static const double lg = 10;
  static const double xl = 12;
  static const double x2l = 14;
  static const double sheet = 22;
  static const double pill = 999;
}
