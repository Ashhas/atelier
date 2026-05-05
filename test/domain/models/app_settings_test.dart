import 'package:atelier/domain/models/app_settings.dart';
import 'package:atelier/domain/models/enums/font_scale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppSettings', () {
    test('default values are light theme + medium font scale', () {
      const s = AppSettings();
      expect(s.themeMode, ThemeMode.light);
      expect(s.fontScale, FontScale.medium);
    });

    test('copyWith replaces only the fields provided', () {
      const s = AppSettings();
      final t = s.copyWith(themeMode: ThemeMode.dark);
      expect(t.themeMode, ThemeMode.dark);
      expect(t.fontScale, FontScale.medium);

      final f = s.copyWith(fontScale: FontScale.large);
      expect(f.themeMode, ThemeMode.light);
      expect(f.fontScale, FontScale.large);
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
