enum FontScale {
  small(0.92),
  medium(1.0),
  large(1.10);

  const FontScale(this.multiplier);
  final double multiplier;
}
