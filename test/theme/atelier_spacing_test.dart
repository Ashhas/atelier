import 'package:atelier/theme/atelier_spacing.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AtelierSpacing scale', () {
    test('exposes the 9 base tokens with expected values', () {
      expect(AtelierSpacing.xs, 2);
      expect(AtelierSpacing.sm, 4);
      expect(AtelierSpacing.md, 6);
      expect(AtelierSpacing.base, 8);
      expect(AtelierSpacing.lg, 10);
      expect(AtelierSpacing.xl, 14);
      expect(AtelierSpacing.x2l, 16);
      expect(AtelierSpacing.x3l, 22);
      expect(AtelierSpacing.x4l, 28);
    });

    test('sums-as-needed cover common in-between values', () {
      expect(AtelierSpacing.base + AtelierSpacing.sm, 12);
      expect(AtelierSpacing.xl + AtelierSpacing.sm, 18);
      expect(AtelierSpacing.xl + AtelierSpacing.md, 20);
    });
  });

  group('AtelierRadii scale', () {
    test('exposes the radii tokens with expected values', () {
      expect(AtelierRadii.sm, 6);
      expect(AtelierRadii.md, 8);
      expect(AtelierRadii.lg, 10);
      expect(AtelierRadii.xl, 12);
      expect(AtelierRadii.x2l, 14);
      expect(AtelierRadii.sheet, 22);
      expect(AtelierRadii.pill, 999);
    });
  });
}
