import 'package:atelier/theme/atelier_colors.dart';
import 'package:atelier/theme/atelier_palette.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AtelierTheme', () {
    test('light theme has the right brightness + scaffold colour', () {
      final t = AtelierTheme.light();
      expect(t.brightness, Brightness.light);
      expect(t.scaffoldBackgroundColor, AtelierColors.light.bg);
    });

    test('dark theme has the right brightness + scaffold colour', () {
      final t = AtelierTheme.dark();
      expect(t.brightness, Brightness.dark);
      expect(t.scaffoldBackgroundColor, AtelierColors.dark.bg);
    });

    testWidgets('paletteOf returns light palette in light theme', (tester) async {
      AtelierPalette? captured;
      await tester.pumpWidget(
        MaterialApp(
          theme: AtelierTheme.light(),
          home: Builder(
            builder: (ctx) {
              captured = AtelierTheme.paletteOf(ctx);
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      expect(captured, AtelierColors.light);
    });

    testWidgets('paletteOf returns dark palette in dark theme', (tester) async {
      AtelierPalette? captured;
      await tester.pumpWidget(
        MaterialApp(
          theme: AtelierTheme.light(),
          darkTheme: AtelierTheme.dark(),
          themeMode: ThemeMode.dark,
          home: Builder(
            builder: (ctx) {
              captured = AtelierTheme.paletteOf(ctx);
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      expect(captured, AtelierColors.dark);
    });
  });
}
