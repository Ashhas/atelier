import 'package:atelier/presentation/common/segmented/segmented.dart';
import 'package:atelier/presentation/common/segmented/segmented_option.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders all options and calls onChanged on tap', (tester) async {
    String? selected;
    await tester.pumpWidget(MaterialApp(
      theme: AtelierTheme.light(),
      home: Scaffold(
        body: Segmented<String>(
          value: 'a',
          options: const [
            SegmentedOptionData(value: 'a', label: 'A'),
            SegmentedOptionData(value: 'b', label: 'B'),
            SegmentedOptionData(value: 'c', label: 'C'),
          ],
          onChanged: (v) => selected = v,
        ),
      ),
    ));

    expect(find.text('A'), findsOneWidget);
    expect(find.text('B'), findsOneWidget);
    expect(find.text('C'), findsOneWidget);

    await tester.tap(find.text('B'));
    await tester.pump();
    expect(selected, 'b');
  });
}
