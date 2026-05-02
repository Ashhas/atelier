import 'package:atelier/theme/atelier_theme.dart';
import 'package:atelier/theme/atelier_typography.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const _PreviewApp());
}

class _PreviewApp extends StatelessWidget {
  const _PreviewApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AtelierTheme.light(),
      darkTheme: AtelierTheme.dark(),
      home: Scaffold(
        body: Center(
          child: Text(
            'Atelier',
            style: AtelierTypography.serifDisplay,
          ),
        ),
      ),
    );
  }
}
