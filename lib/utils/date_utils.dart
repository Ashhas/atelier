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
