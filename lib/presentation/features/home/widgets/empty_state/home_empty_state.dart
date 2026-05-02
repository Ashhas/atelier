import 'package:atelier/presentation/features/home/widgets/empty_state/home_empty_state_action.dart';
import 'package:atelier/presentation/features/home/widgets/empty_state/home_empty_state_body.dart';
import 'package:atelier/presentation/features/home/widgets/empty_state/home_empty_state_brand.dart';
import 'package:atelier/presentation/features/home/widgets/empty_state/home_empty_state_eyebrow.dart';
import 'package:atelier/theme/atelier_spacing.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:flutter/material.dart';

/// Blank-slate empty state shown when no pockets exist (spec §3.9).
///
/// A large dashed-border container occupying the grid region, with vertically
/// and horizontally centered content stack (gap 14px).
class HomeEmptyState extends StatelessWidget {
  const HomeEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final c = AtelierTheme.paletteOf(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AtelierSpacing.x3l, // 22
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          vertical: AtelierSpacing.x4l, // 28
        ),
        decoration: BoxDecoration(
          border: Border.all(color: c.rule),
          borderRadius: BorderRadius.circular(AtelierRadii.x2l), // 14
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            HomeEmptyStateBrand(),
            SizedBox(height: AtelierSpacing.x2l), // 16
            HomeEmptyStateEyebrow(),
            SizedBox(height: AtelierSpacing.xl), // 14
            HomeEmptyStateBody(),
            SizedBox(height: AtelierSpacing.xl), // 14
            HomeEmptyStateAction(),
          ],
        ),
      ),
    );
  }
}
