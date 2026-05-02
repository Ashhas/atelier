import 'package:atelier/theme/atelier_spacing.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:flutter/material.dart';

class GoalRowStarButton extends StatelessWidget {
  const GoalRowStarButton({
    super.key,
    required this.starred,
    required this.onTap,
  });

  final bool starred;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = AtelierTheme.paletteOf(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(AtelierSpacing.xs),
        child: Text(
          starred ? '★' : '☆',
          style: TextStyle(
            color: starred ? p.starInk : p.mute,
            fontSize: 12,
            height: 1,
          ),
        ),
      ),
    );
  }
}
