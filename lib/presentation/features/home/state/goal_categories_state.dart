import 'package:atelier/domain/models/goal_category.dart';
import 'package:equatable/equatable.dart';

class GoalCategoriesState extends Equatable {
  const GoalCategoriesState({this.categories = const [], this.loaded = false});

  final List<GoalCategory> categories;
  final bool loaded;

  /// All real (non-Open) categories.
  List<GoalCategory> get realCategories =>
      categories.where((c) => !c.isAddSlot).toList(growable: false);

  /// Whether the user has zero real pockets (drives the empty-state UI).
  bool get isEmpty => loaded && realCategories.isEmpty;

  GoalCategoriesState copyWith({List<GoalCategory>? categories, bool? loaded}) =>
      GoalCategoriesState(
        categories: categories ?? this.categories,
        loaded: loaded ?? this.loaded,
      );

  @override
  List<Object?> get props => [categories, loaded];
}
