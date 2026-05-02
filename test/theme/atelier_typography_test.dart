import 'package:atelier/theme/atelier_typography.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  group('AtelierTypography', () {
    testWidgets(
      'mono tokens use JetBrains Mono with the right size + spacing',
      (WidgetTester tester) async {
        expect(
          AtelierTypography.monoMicro.fontFamily,
          contains('JetBrainsMono'),
        );
        expect(AtelierTypography.monoMicro.fontSize, 8.5);
        expect(AtelierTypography.monoMicro.letterSpacing, 1.2);
        expect(AtelierTypography.monoMicro.fontWeight, FontWeight.w600);

        expect(AtelierTypography.monoEyebrow.fontSize, 9);
        expect(AtelierTypography.monoEyebrow.letterSpacing, 1.8);

        expect(AtelierTypography.monoLabel.fontSize, 10);
        expect(AtelierTypography.monoLabel.letterSpacing, 1.4);

        await tester.pumpAndSettle();
      },
    );

    testWidgets('serif tokens use Fraunces italic with the right sizes', (
      WidgetTester tester,
    ) async {
      expect(AtelierTypography.serifDisplay.fontFamily, contains('Fraunces'));
      expect(AtelierTypography.serifDisplay.fontStyle, FontStyle.italic);
      expect(AtelierTypography.serifDisplay.fontSize, 24);
      expect(AtelierTypography.serifDisplay.letterSpacing, -0.5);

      expect(AtelierTypography.serifTitle.fontSize, 17);
      expect(AtelierTypography.serifTitle.letterSpacing, -0.3);

      expect(AtelierTypography.serifBody.fontSize, 12.5);
      expect(AtelierTypography.serifBody.letterSpacing, -0.2);

      await tester.pumpAndSettle();
    });

    testWidgets('sans tokens use Inter', (WidgetTester tester) async {
      expect(AtelierTypography.sansBody.fontFamily, contains('Inter'));
      expect(AtelierTypography.sansBody.fontSize, 13);

      expect(AtelierTypography.sansLabel.fontSize, 14);
      expect(AtelierTypography.sansLabel.fontWeight, FontWeight.w600);

      await tester.pumpAndSettle();
    });
  });
}
