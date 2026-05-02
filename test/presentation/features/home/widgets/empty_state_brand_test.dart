import 'package:atelier/presentation/features/home/widgets/empty_state/home_empty_state_brand.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('HomeEmptyStateBrand renders the wordmark + meta line', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AtelierTheme.light(),
        home: const Scaffold(body: Center(child: HomeEmptyStateBrand())),
      ),
    );

    expect(find.text('atelier'), findsOneWidget);
    expect(find.text('2026'), findsOneWidget);
    expect(find.text('LOCAL-FIRST'), findsOneWidget);
  });
}
