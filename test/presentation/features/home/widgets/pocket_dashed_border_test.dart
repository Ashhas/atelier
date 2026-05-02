import 'package:atelier/presentation/features/home/widgets/pocket/pocket_dashed_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PocketDashedBorder', () {
    testWidgets('paints child without errors', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 120,
                height: 120,
                child: PocketDashedBorder(
                  color: Color(0xFFEDEDED),
                  child: SizedBox.expand(),
                ),
              ),
            ),
          ),
        ),
      );
      expect(find.byType(PocketDashedBorder), findsOneWidget);
      expect(find.byType(CustomPaint), findsWidgets);
      expect(tester.takeException(), isNull);
    });

    testWidgets('forwards child to the painter\'s subtree', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 120,
                height: 120,
                child: PocketDashedBorder(
                  color: Color(0xFFEDEDED),
                  child: Text('inside'),
                ),
              ),
            ),
          ),
        ),
      );
      expect(find.text('inside'), findsOneWidget);
    });

    testWidgets('repaints when color changes', (tester) async {
      Widget build(Color color) => MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 120,
              height: 120,
              child: PocketDashedBorder(
                color: color,
                child: const SizedBox.expand(),
              ),
            ),
          ),
        ),
      );

      await tester.pumpWidget(build(const Color(0xFFEDEDED)));
      await tester.pumpWidget(build(const Color(0xFF0A0A0A)));
      // No exception during repaint == pass.
      expect(tester.takeException(), isNull);
    });
  });
}
