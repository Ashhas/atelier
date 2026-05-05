import 'package:atelier/domain/models/enums/content_font.dart';
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

    testWidgets('content-font tokens resolve to selected family upright', (
      WidgetTester tester,
    ) async {
      final plex = AtelierTypography.serifTitleUpright(ContentFont.plex);
      expect(plex.fontFamily?.toLowerCase(), contains('plex'));
      expect(plex.fontStyle, FontStyle.normal);
      expect(plex.fontSize, 17);

      final manrope = AtelierTypography.serifBodyUpright(ContentFont.manrope);
      expect(manrope.fontFamily, contains('Manrope'));
      expect(manrope.fontStyle, FontStyle.normal);

      final inter = AtelierTypography.serifDisplayUpright(ContentFont.inter);
      expect(inter.fontFamily, contains('Inter'));
      expect(inter.fontStyle, FontStyle.normal);

      // Serif option is the only one that switches to italic.
      final serif = AtelierTypography.serifTitleUpright(ContentFont.fraunces);
      expect(serif.fontFamily, contains('Fraunces'));
      expect(serif.fontStyle, FontStyle.italic);

      await tester.pumpAndSettle();
    });
  });
}
