import 'package:atelier/presentation/features/detail/detail_screen.dart';
import 'package:flutter/material.dart';

/// Thin wrapper that mounts [DetailScreen] for the given pocket.
///
/// Cubits (GoalsCubit, YearGoalsCubit, GoalCategoriesCubit) are provided at
/// the app shell via [MultiBlocProvider] in [AtelierApp], so no additional
/// providers are needed here.
class DetailContainer extends StatelessWidget {
  const DetailContainer({super.key, required this.goalCategoryId});

  final String goalCategoryId;

  @override
  Widget build(BuildContext context) =>
      DetailScreen(goalCategoryId: goalCategoryId);
}
