import 'package:atelier/presentation/features/home/widgets/tick_strip/tick_strip.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders today label "12th · 39%" on May 12', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AtelierTheme.light(),
        home: Scaffold(body: TickStrip(now: DateTime(2026, 5, 12))),
      ),
    );
    // Day-with-ordinal and the percent share a single Text.rich span, so
    // `find.textContaining` looks at the rendered text content.
    expect(find.textContaining('12th'), findsOneWidget);
    expect(find.textContaining('39%'), findsOneWidget);
  });
}
