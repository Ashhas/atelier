import 'package:atelier/utils/date_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AtelierDateUtils', () {
    test('daysInMonth handles 28/29/30/31', () {
      expect(AtelierDateUtils.daysInMonth(2026, 2), 28);
      expect(AtelierDateUtils.daysInMonth(2024, 2), 29);
      expect(AtelierDateUtils.daysInMonth(2026, 4), 30);
      expect(AtelierDateUtils.daysInMonth(2026, 5), 31);
    });

    test('daysSince computes whole-day difference', () {
      final today = DateTime(2026, 5, 12);
      expect(AtelierDateUtils.daysSince(today, today), 0);
      expect(AtelierDateUtils.daysSince(DateTime(2026, 5, 11), today), 1);
      expect(AtelierDateUtils.daysSince(DateTime(2026, 5, 9), today), 3);
    });

    test('formatDaysSince renders the label per spec', () {
      expect(AtelierDateUtils.formatDaysSince(0), 'today');
      expect(AtelierDateUtils.formatDaysSince(1), '1 day');
      expect(AtelierDateUtils.formatDaysSince(3), '3 days');
    });

    test('monthName returns the english name', () {
      expect(AtelierDateUtils.monthName(5), 'May');
      expect(AtelierDateUtils.monthName(1), 'January');
      expect(AtelierDateUtils.monthName(12), 'December');
    });

    test('ordinalSuffix handles 1/2/3 and the 11/12/13 exceptions', () {
      expect(AtelierDateUtils.ordinalSuffix(1), 'st');
      expect(AtelierDateUtils.ordinalSuffix(2), 'nd');
      expect(AtelierDateUtils.ordinalSuffix(3), 'rd');
      expect(AtelierDateUtils.ordinalSuffix(4), 'th');
      expect(AtelierDateUtils.ordinalSuffix(10), 'th');
      // 11/12/13 are always 'th' even though they end in 1/2/3.
      expect(AtelierDateUtils.ordinalSuffix(11), 'th');
      expect(AtelierDateUtils.ordinalSuffix(12), 'th');
      expect(AtelierDateUtils.ordinalSuffix(13), 'th');
      // Back to st/nd/rd from 21 onwards.
      expect(AtelierDateUtils.ordinalSuffix(21), 'st');
      expect(AtelierDateUtils.ordinalSuffix(22), 'nd');
      expect(AtelierDateUtils.ordinalSuffix(23), 'rd');
      expect(AtelierDateUtils.ordinalSuffix(31), 'st');
    });
  });
}
