import 'package:atelier/theme/atelier_palette.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:flutter/material.dart';

class TickStripBaseline extends StatelessWidget {
  const TickStripBaseline({super.key});

  @override
  Widget build(BuildContext context) {
    final AtelierPalette p = AtelierTheme.paletteOf(context);
    return Positioned(
      left: 0,
      right: 0,
      top: 13,
      child: Container(height: 1, color: p.rule),
    );
  }
}
