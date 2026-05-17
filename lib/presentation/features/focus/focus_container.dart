import 'package:atelier/presentation/features/focus/focus_screen.dart';
import 'package:flutter/material.dart';

/// Thin wrapper that mounts [FocusScreen].
///
/// Cubits (GoalCategoriesCubit, GoalsCubit) are provided at the app
/// shell via MultiBlocProvider in AtelierApp, so no additional providers
/// are needed here.
class FocusContainer extends StatelessWidget {
  const FocusContainer({super.key});

  @override
  Widget build(BuildContext context) => const FocusScreen();
}
