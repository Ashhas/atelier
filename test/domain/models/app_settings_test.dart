import 'package:atelier/domain/models/app_settings.dart';
import 'package:atelier/domain/models/enums/font_scale.dart';
import 'package:atelier/domain/models/enums/pocket_year_line_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppSettings', () {
    test('default values are light theme, medium font, one-line year goals', () {
      const s = AppSettings();
      expect(s.themeMode, ThemeMode.light);
      expect(s.fontScale, FontScale.medium);
      expect(s.pocketYearLineMode, PocketYearLineMode.oneLine);
    });

    test('copyWith replaces only the fields provided', () {
      const s = AppSettings();
      final t = s.copyWith(themeMode: ThemeMode.dark);
      expect(t.themeMode, ThemeMode.dark);
      expect(t.fontScale, FontScale.medium);
      expect(t.pocketYearLineMode, PocketYearLineMode.oneLine);

      final f = s.copyWith(fontScale: FontScale.large);
      expect(f.themeMode, ThemeMode.light);
      expect(f.fontScale, FontScale.large);

      final l = s.copyWith(pocketYearLineMode: PocketYearLineMode.full);
      expect(l.pocketYearLineMode, PocketYearLineMode.full);
      expect(l.fontScale, FontScale.medium);
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
