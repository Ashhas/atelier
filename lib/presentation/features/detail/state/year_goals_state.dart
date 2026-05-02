import 'package:atelier/domain/models/year_goal.dart';
import 'package:equatable/equatable.dart';

class YearGoalsState extends Equatable {
  const YearGoalsState({this.yearGoals = const [], this.loaded = false});

  final List<YearGoal> yearGoals;
  final bool loaded;

  /// Year goals for a specific category.
  List<YearGoal> forCategory(String goalCategoryId) => yearGoals
      .where((g) => g.goalCategoryId == goalCategoryId)
      .toList(growable: false);

  YearGoalsState copyWith({List<YearGoal>? yearGoals, bool? loaded}) =>
      YearGoalsState(
        yearGoals: yearGoals ?? this.yearGoals,
        loaded: loaded ?? this.loaded,
      );

  @override
  List<Object?> get props => [yearGoals, loaded];
}
