import 'package:equatable/equatable.dart';

class GoalCategory extends Equatable {
  const GoalCategory({
    required this.id,
    required this.name,
    required this.order,
    this.isAddSlot = false,
  });

  final String id;
  final String name;
  final int order;
  final bool isAddSlot;

  GoalCategory copyWith({String? id, String? name, int? order, bool? isAddSlot}) =>
      GoalCategory(
        id: id ?? this.id,
        name: name ?? this.name,
        order: order ?? this.order,
        isAddSlot: isAddSlot ?? this.isAddSlot,
      );

  @override
  List<Object?> get props => [id, name, order, isAddSlot];
}
