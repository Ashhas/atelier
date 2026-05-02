import 'package:equatable/equatable.dart';

class Goal extends Equatable {
  const Goal({
    required this.id,
    required this.goalCategoryId,
    required this.title,
    required this.addedAt,
    this.starred = false,
  });

  final String id;
  final String goalCategoryId;
  final String title;
  final bool starred;
  final DateTime addedAt;

  Goal copyWith({
    String? id,
    String? goalCategoryId,
    String? title,
    bool? starred,
    DateTime? addedAt,
  }) =>
      Goal(
        id: id ?? this.id,
        goalCategoryId: goalCategoryId ?? this.goalCategoryId,
        title: title ?? this.title,
        starred: starred ?? this.starred,
        addedAt: addedAt ?? this.addedAt,
      );

  @override
  List<Object?> get props => [id, goalCategoryId, title, starred, addedAt];
}
