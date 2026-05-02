import 'package:atelier/presentation/features/home/state/manage_mode_cubit.dart';
import 'package:atelier/presentation/features/home/state/manage_mode_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('enter sets isManaging to true', () async {
    final cubit = ManageModeCubit();
    final emitted = <ManageModeState>[];
    final sub = cubit.stream.listen(emitted.add);
    cubit.enter();
    await Future<void>.delayed(Duration.zero);
    await sub.cancel();
    expect(emitted, [const ManageModeState(isManaging: true)]);
  });

  test('exit sets isManaging to false from a managing state', () async {
    final cubit = ManageModeCubit()..enter();
    // Wait a microtask for the synchronous emit from enter() to flush.
    await Future<void>.delayed(Duration.zero);
    final emitted = <ManageModeState>[];
    final sub = cubit.stream.listen(emitted.add);
    cubit.exit();
    await Future<void>.delayed(Duration.zero);
    await sub.cancel();
    expect(emitted, [const ManageModeState(isManaging: false)]);
  });
}
