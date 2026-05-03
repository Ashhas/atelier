class AtelierDateUtils {
  const AtelierDateUtils._();

  static int daysInMonth(int year, int month) =>
      DateTime(year, month + 1, 0).day;

  static int daysSince(DateTime from, DateTime to) {
    final fromDay = DateTime(from.year, from.month, from.day);
    final toDay = DateTime(to.year, to.month, to.day);
    return toDay.difference(fromDay).inDays;
  }

  static String formatDaysSince(int days) {
    if (days <= 0) return 'today';
    if (days == 1) return '1 day';
    return '$days days';
  }

  /// Returns the English ordinal suffix for [n]: 'st', 'nd', 'rd', or 'th'.
  /// Handles the 11/12/13 exceptions (all take 'th' even though they end in
  /// 1/2/3). Returns 'th' for non-positive numbers.
  static String ordinalSuffix(int n) {
    if (n <= 0) return 'th';
    final lastTwo = n % 100;
    if (lastTwo >= 11 && lastTwo <= 13) return 'th';
    switch (n % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  static String monthName(int month) {
    const names = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return names[month - 1];
  }
}
