import 'package:atelier/presentation/features/home/home_screen.dart';
import 'package:flutter/material.dart';

/// Thin wrapper that mounts [HomeScreen].
///
/// Cubits (GoalCategoriesCubit, ManageModeCubit) are provided at the app shell
/// via [MultiBlocProvider] in [AtelierApp], so no additional providers are
/// needed here.
class HomeContainer extends StatelessWidget {
  const HomeContainer({super.key});

  @override
  Widget build(BuildContext context) => const HomeScreen();
}
