import 'package:atelier/theme/atelier_spacing.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:atelier/theme/atelier_typography.dart';
import 'package:flutter/material.dart';

/// Brand mark shown at the top of the empty state — Fraunces italic
/// "atelier" wordmark plus a small "2026 · LOCAL-FIRST" meta line with the
/// accent green dot used as the only color moment (matches the logo
/// system's in-context splash).
class HomeEmptyStateBrand extends StatelessWidget {
  const HomeEmptyStateBrand({super.key});

  @override
  Widget build(BuildContext context) {
    final c = AtelierTheme.paletteOf(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'atelier',
          style: AtelierTypography.serifDisplay.copyWith(
            color: c.ink,
            fontSize: 36,
            letterSpacing: -0.5,
            height: 0.95,
          ),
        ),
        const SizedBox(height: AtelierSpacing.base),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '2026',
              style: AtelierTypography.monoMicro.copyWith(
                color: c.mute,
                fontSize: 9,
                letterSpacing: 1.6,
              ),
            ),
            const SizedBox(width: AtelierSpacing.base),
            Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                color: c.accent,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: AtelierSpacing.base),
            Text(
              'LOCAL-FIRST',
              style: AtelierTypography.monoMicro.copyWith(
                color: c.mute,
                fontSize: 9,
                letterSpacing: 1.6,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
