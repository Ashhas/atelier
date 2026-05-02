import 'package:atelier/domain/models/goal.dart';
import 'package:equatable/equatable.dart';

class GoalsState extends Equatable {
  const GoalsState({this.goals = const [], this.loaded = false});

  final List<Goal> goals;
  final bool loaded;

  /// Goals for a specific category, starred-first then insertion order.
  List<Goal> forCategory(String goalCategoryId) => goals
      .where((g) => g.goalCategoryId == goalCategoryId)
      .toList(growable: false);

  GoalsState copyWith({List<Goal>? goals, bool? loaded}) =>
      GoalsState(goals: goals ?? this.goals, loaded: loaded ?? this.loaded);

  @override
  List<Object?> get props => [goals, loaded];
}
