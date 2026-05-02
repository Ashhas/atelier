import 'package:atelier/presentation/features/home/state/manage_mode_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManageModeCubit extends Cubit<ManageModeState> {
  ManageModeCubit() : super(const ManageModeState());

  void enter() => emit(const ManageModeState(isManaging: true));
  void exit() => emit(const ManageModeState(isManaging: false));
  void toggle() => state.isManaging ? exit() : enter();
}
