import 'package:atelier/presentation/features/detail/state/goals_cubit.dart';
import 'package:atelier/presentation/features/detail/state/goals_state.dart';
import 'package:atelier/presentation/features/detail/state/year_goals_cubit.dart';
import 'package:atelier/presentation/features/detail/state/year_goals_state.dart';
import 'package:atelier/presentation/features/detail/widgets/add_bar/add_bar.dart';
import 'package:atelier/presentation/features/detail/widgets/add_bar/add_bar_input.dart';
import 'package:atelier/presentation/features/detail/widgets/add_bar/add_bar_placeholder.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockGoalsCubit extends Mock implements GoalsCubit {}

class _MockYearGoalsCubit extends Mock implements YearGoalsCubit {}

Widget _wrap({required GoalsCubit goals, required YearGoalsCubit yearGoals}) =>
    MaterialApp(
      theme: AtelierTheme.light(),
      home: Scaffold(
        body: MultiBlocProvider(
          providers: [
            BlocProvider<GoalsCubit>.value(value: goals),
            BlocProvider<YearGoalsCubit>.value(value: yearGoals),
          ],
          child: const AddBar(goalCategoryId: 'cat1'),
        ),
      ),
    );

void main() {
  late _MockGoalsCubit goalsCubit;
  late _MockYearGoalsCubit yearGoalsCubit;

  setUp(() {
    goalsCubit = _MockGoalsCubit();
    yearGoalsCubit = _MockYearGoalsCubit();
    when(() => goalsCubit.state).thenReturn(const GoalsState());
    when(() => goalsCubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => yearGoalsCubit.state).thenReturn(const YearGoalsState());
    when(() => yearGoalsCubit.stream).thenAnswer((_) => const Stream.empty());
  });

  group('AddBar', () {
    testWidgets('starts with placeholder, not input', (tester) async {
      await tester.pumpWidget(
        _wrap(goals: goalsCubit, yearGoals: yearGoalsCubit),
      );
      expect(find.byType(AddBarPlaceholder), findsOneWidget);
      expect(find.byType(AddBarInput), findsNothing);
    });

    testWidgets('tapping placeholder reveals input', (tester) async {
      await tester.pumpWidget(
        _wrap(goals: goalsCubit, yearGoals: yearGoalsCubit),
      );
      await tester.tap(find.byType(AddBarPlaceholder));
      await tester.pumpAndSettle();
      expect(find.byType(AddBarInput), findsOneWidget);
    });

    testWidgets('submitting in MONTH mode calls GoalsCubit.add', (
      tester,
    ) async {
      when(
        () => goalsCubit.add(
          goalCategoryId: any(named: 'goalCategoryId'),
          title: any(named: 'title'),
        ),
      ).thenAnswer((_) async {});

      await tester.pumpWidget(
        _wrap(goals: goalsCubit, yearGoals: yearGoalsCubit),
      );
      await tester.tap(find.byType(AddBarPlaceholder));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Run 5K');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      verify(
        () => goalsCubit.add(goalCategoryId: 'cat1', title: 'Run 5K'),
      ).called(1);
    });

    testWidgets('submitting empty input is a no-op', (tester) async {
      await tester.pumpWidget(
        _wrap(goals: goalsCubit, yearGoals: yearGoalsCubit),
      );
      await tester.tap(find.byType(AddBarPlaceholder));
      await tester.pumpAndSettle();
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      verifyNever(
        () => goalsCubit.add(
          goalCategoryId: any(named: 'goalCategoryId'),
          title: any(named: 'title'),
        ),
      );
    });

    testWidgets(
      'switching to YEAR mode then submitting calls YearGoalsCubit.add',
      (tester) async {
        when(
          () => yearGoalsCubit.add(
            goalCategoryId: any(named: 'goalCategoryId'),
            title: any(named: 'title'),
          ),
        ).thenAnswer((_) async {});

        await tester.pumpWidget(
          _wrap(goals: goalsCubit, yearGoals: yearGoalsCubit),
        );
        // Switch to YEAR
        await tester.tap(find.text('YEAR'));
        await tester.pumpAndSettle();
        // Open input
        await tester.tap(find.byType(AddBarPlaceholder));
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextField), 'Run marathon');
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();

        verify(
          () =>
              yearGoalsCubit.add(goalCategoryId: 'cat1', title: 'Run marathon'),
        ).called(1);
      },
    );
  });
}
