import 'package:equatable/equatable.dart';

class ManageModeState extends Equatable {
  const ManageModeState({this.isManaging = false});

  final bool isManaging;

  @override
  List<Object?> get props => [isManaging];
}
