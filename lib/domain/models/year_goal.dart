import 'package:equatable/equatable.dart';

class YearGoal extends Equatable {
  const YearGoal({
    required this.id,
    required this.goalCategoryId,
    required this.title,
    this.expanded = true,
  });

  final String id;
  final String goalCategoryId;
  final String title;
  final bool expanded;

  YearGoal copyWith({
    String? id,
    String? goalCategoryId,
    String? title,
    bool? expanded,
  }) => YearGoal(
    id: id ?? this.id,
    goalCategoryId: goalCategoryId ?? this.goalCategoryId,
    title: title ?? this.title,
    expanded: expanded ?? this.expanded,
  );

  @override
  List<Object?> get props => [id, goalCategoryId, title, expanded];
}
