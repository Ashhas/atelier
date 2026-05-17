/// How many lines a year-goal title may occupy in the pocket preview.
///
/// `maxLines` returns the int passed to `Text.maxLines`; `null` means
/// unbounded (the title can wrap to as many lines as it needs).
enum PocketYearLineMode {
  oneLine(1),
  twoLines(2),
  full(null);

  const PocketYearLineMode(this.maxLines);
  final int? maxLines;
}
