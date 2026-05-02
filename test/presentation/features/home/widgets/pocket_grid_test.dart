import 'package:atelier/domain/models/goal_category.dart';
import 'package:atelier/presentation/features/home/state/goal_categories_cubit.dart';
import 'package:atelier/presentation/features/home/state/goal_categories_state.dart';
import 'package:atelier/presentation/features/home/state/manage_mode_cubit.dart';
import 'package:atelier/presentation/features/home/state/manage_mode_state.dart';
import 'package:atelier/presentation/features/home/widgets/grid/pocket_grid.dart';
import 'package:atelier/presentation/features/home/widgets/pocket/pocket.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockGoalCategoriesCubit extends Mock implements GoalCategoriesCubit {}

class _MockManageModeCubit extends Mock implements ManageModeCubit {}

Widget _wrap(
  Widget child, {
  required GoalCategoriesCubit categories,
  required ManageModeCubit manage,
}) => MaterialApp(
  theme: AtelierTheme.light(),
  home: Scaffold(
    body: MultiBlocProvider(
      providers: [
        BlocProvider<GoalCategoriesCubit>.value(value: categories),
        BlocProvider<ManageModeCubit>.value(value: manage),
      ],
      child: child,
    ),
  ),
);

void main() {
  late _MockGoalCategoriesCubit categoriesCubit;
  late _MockManageModeCubit manageCubit;

  setUp(() {
    categoriesCubit = _MockGoalCategoriesCubit();
    manageCubit = _MockManageModeCubit();

    when(() => categoriesCubit.state).thenReturn(
      const GoalCategoriesState(
        loaded: true,
        categories: [
          GoalCategory(id: 'w', name: 'Work', order: 0),
          GoalCategory(id: 'b', name: 'Body', order: 1),
          GoalCategory(id: 'open', name: 'Open', order: 2, isAddSlot: true),
        ],
      ),
    );
    when(() => categoriesCubit.stream).thenAnswer((_) => const Stream.empty());

    when(
      () => manageCubit.state,
    ).thenReturn(const ManageModeState(isManaging: false));
    when(() => manageCubit.stream).thenAnswer((_) => const Stream.empty());
  });

  testWidgets('PocketGrid renders one Pocket per visible category §3.2', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        const PocketGrid(),
        categories: categoriesCubit,
        manage: manageCubit,
      ),
    );
    await tester.pump();
    // 2 real + 1 Open add-slot = 3 pockets
    expect(find.byType(Pocket), findsNWidgets(3));
  });

  testWidgets('Open add-slot hidden in manage mode §3.6', (tester) async {
    when(
      () => manageCubit.state,
    ).thenReturn(const ManageModeState(isManaging: true));

    await tester.pumpWidget(
      _wrap(
        const PocketGrid(),
        categories: categoriesCubit,
        manage: manageCubit,
      ),
    );
    await tester.pump();
    // Only 2 pockets (Open is hidden)
    expect(find.byType(Pocket), findsNWidgets(2));
  });
}
