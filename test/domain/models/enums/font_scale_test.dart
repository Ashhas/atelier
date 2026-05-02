import 'package:atelier/domain/models/enums/font_scale.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FontScale', () {
    test('exposes three values with the right multipliers', () {
      expect(FontScale.values.length, 3);
      expect(FontScale.small.multiplier, 0.92);
      expect(FontScale.medium.multiplier, 1.0);
      expect(FontScale.large.multiplier, 1.10);
    });
  });
}
