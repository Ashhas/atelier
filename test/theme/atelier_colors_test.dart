import 'package:atelier/theme/atelier_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AtelierColors.light', () {
    test('matches prototype palette', () {
      const p = AtelierColors.light;
      expect(p.bg, const Color(0xFFFFFFFF));
      expect(p.ink, const Color(0xFF0A0A0A));
      expect(p.sub, const Color(0xFF525252));
      expect(p.mute, const Color(0xFFA3A3A3));
      expect(p.rule, const Color(0xFFEDEDED));
      expect(p.accent, const Color(0xFF0A0A0A));
      expect(p.chip, const Color(0xFFFAFAFA));
      expect(p.pocket, const Color(0xFFFFFFFF));
      expect(p.surface, const Color(0xFFFAFAFA));
      expect(p.starBg, const Color(0xFFEDEDED));
      expect(p.starBorder, const Color(0xFFDCDCDC));
      expect(p.starInk, const Color(0xFF0A0A0A));
      expect(p.yearBg, const Color(0xFFF5F5F2));
      expect(p.yearInk, const Color(0xFF0A0A0A));
      expect(p.error, const Color(0xFFB91C1C));
    });
  });

  group('AtelierColors.dark', () {
    test('matches prototype palette', () {
      const p = AtelierColors.dark;
      expect(p.bg, const Color(0xFF121212));
      expect(p.ink, const Color(0xFFFFFFFF));
      expect(p.sub, const Color(0xFFA7A7A7));
      expect(p.mute, const Color(0xFF727272));
      expect(p.rule, const Color(0xFF2A2A2A));
      expect(p.accent, const Color(0xFF1ED760));
      expect(p.chip, const Color(0xFF1F1F1F));
      expect(p.pocket, const Color(0xFF181818));
      expect(p.surface, const Color(0xFF181818));
      expect(p.starBg, const Color(0xFF282828));
      expect(p.starBorder, const Color(0xFF3E3E3E));
      expect(p.starInk, const Color(0xFFFFFFFF));
      expect(p.yearBg, const Color(0xFF181818));
      expect(p.yearInk, const Color(0xFFFFFFFF));
      expect(p.error, const Color(0xFFC54545));
    });
  });
}
