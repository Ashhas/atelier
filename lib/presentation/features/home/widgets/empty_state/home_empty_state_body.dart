import 'package:atelier/theme/atelier_spacing.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:atelier/theme/atelier_typography.dart';
import 'package:flutter/material.dart';

/// Display title + explanatory body copy for the empty state (spec §3.9).
class HomeEmptyStateBody extends StatelessWidget {
  const HomeEmptyStateBody({super.key});

  @override
  Widget build(BuildContext context) {
    final c = AtelierTheme.paletteOf(context);
    return Column(
      children: [
        // Italic display title (spec §3.9: fontSize 26, height 1.2)
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 260),
          child: Text(
            'Your year, one pocket at a time.',
            style: AtelierTypography.serifDisplay.copyWith(
              fontSize: 26,
              height: 1.2,
              color: c.ink,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: AtelierSpacing.xl),
        // Sans body copy (spec §3.9: Inter 13px, sub, lineHeight 1.4)
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 240),
          child: Text(
            'Pockets are categories for your goals — Work, Body, Mind, '
            'anything you want. Tap below to start your first one.',
            style: AtelierTypography.sansBody.copyWith(
              color: c.sub,
              height: 1.4,
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
