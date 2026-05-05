import 'package:atelier/domain/models/app_settings.dart';
import 'package:atelier/domain/models/enums/content_font.dart';
import 'package:atelier/domain/models/enums/font_scale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppSettings', () {
    test('default values are light theme + medium font scale + plex font', () {
      const s = AppSettings();
      expect(s.themeMode, ThemeMode.light);
      expect(s.fontScale, FontScale.medium);
      expect(s.contentFont, ContentFont.plex);
    });

    test('copyWith replaces only the fields provided', () {
      const s = AppSettings();
      final t = s.copyWith(themeMode: ThemeMode.dark);
      expect(t.themeMode, ThemeMode.dark);
      expect(t.fontScale, FontScale.medium);
      expect(t.contentFont, ContentFont.plex);

      final f = s.copyWith(fontScale: FontScale.large);
      expect(f.themeMode, ThemeMode.light);
      expect(f.fontScale, FontScale.large);

      final cf = s.copyWith(contentFont: ContentFont.fraunces);
      expect(cf.contentFont, ContentFont.fraunces);
      expect(cf.fontScale, FontScale.medium);
    });

    test('value equality holds', () {
      const a = AppSettings();
      const b = AppSettings();
      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);

      const c = AppSettings(themeMode: ThemeMode.dark);
      expect(a, isNot(equals(c)));

      const d = AppSettings(contentFont: ContentFont.inter);
      expect(a, isNot(equals(d)));
    });
  });

  group('ContentFont.isItalic', () {
    test('only the serif option is italic', () {
      expect(ContentFont.plex.isItalic, isFalse);
      expect(ContentFont.manrope.isItalic, isFalse);
      expect(ContentFont.inter.isItalic, isFalse);
      expect(ContentFont.fraunces.isItalic, isTrue);
    });
  });
}
