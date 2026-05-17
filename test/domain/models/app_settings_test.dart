import 'package:atelier/domain/models/app_settings.dart';
import 'package:atelier/domain/models/enums/font_scale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppSettings', () {
    test('default values are light theme, medium font, 1 line, 3 goals', () {
      const s = AppSettings();
      expect(s.themeMode, ThemeMode.light);
      expect(s.fontScale, FontScale.medium);
      expect(s.pocketYearLines, 1);
      expect(s.pocketGoalsPreviewCount, 3);
      expect(s.hasGoalEver, isFalse);
    });

    test('copyWith hasGoalEver flips the latch', () {
      const s = AppSettings();
      final t = s.copyWith(hasGoalEver: true);
      expect(t.hasGoalEver, isTrue);
      expect(t.themeMode, s.themeMode);
    });

    test('copyWith replaces only the fields provided', () {
      const s = AppSettings();

      final t = s.copyWith(themeMode: ThemeMode.dark);
      expect(t.themeMode, ThemeMode.dark);
      expect(t.fontScale, FontScale.medium);
      expect(t.pocketYearLines, 1);
      expect(t.pocketGoalsPreviewCount, 3);

      final f = s.copyWith(fontScale: FontScale.large);
      expect(f.themeMode, ThemeMode.light);
      expect(f.fontScale, FontScale.large);
    });

    test('copyWith with explicit null sets the field to null', () {
      const s = AppSettings();
      // null is a real value here: "Full" / "All" presets. The sentinel
      // pattern in copyWith preserves the distinction between
      // "not provided" and "explicitly null".
      final unbounded = s.copyWith(
        pocketYearLines: null,
        pocketGoalsPreviewCount: null,
      );
      expect(unbounded.pocketYearLines, isNull);
      expect(unbounded.pocketGoalsPreviewCount, isNull);
    });

    test('copyWith omitted args preserve existing values', () {
      const s = AppSettings(pocketYearLines: 4, pocketGoalsPreviewCount: 12);
      final t = s.copyWith(themeMode: ThemeMode.dark);
      expect(t.pocketYearLines, 4);
      expect(t.pocketGoalsPreviewCount, 12);
    });

    test('value equality holds', () {
      const a = AppSettings();
      const b = AppSettings();
      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);

      const c = AppSettings(themeMode: ThemeMode.dark);
      expect(a, isNot(equals(c)));
    });
  });
}
