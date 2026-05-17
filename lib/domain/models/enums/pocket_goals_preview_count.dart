/// How many goals a pocket card may preview before showing "+N more".
///
/// `limit` returns the int passed to `Iterable.take`; `null` means
/// "show all" (no cap, no overflow indicator).
enum PocketGoalsPreviewCount {
  three(3),
  five(5),
  all(null);

  const PocketGoalsPreviewCount(this.limit);
  final int? limit;
}
