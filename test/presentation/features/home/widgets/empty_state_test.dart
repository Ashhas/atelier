import 'package:atelier/presentation/features/home/state/goal_categories_cubit.dart';
import 'package:atelier/presentation/features/home/state/goal_categories_state.dart';
import 'package:atelier/presentation/features/home/widgets/empty_state/home_empty_state.dart';
import 'package:atelier/presentation/features/home/widgets/empty_state/home_empty_state_action.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockGoalCategoriesCubit extends Mock implements GoalCategoriesCubit {}

Widget _wrap(Widget child, {required GoalCategoriesCubit cubit}) => MaterialApp(
  theme: AtelierTheme.light(),
  home: Scaffold(
    body: BlocProvider<GoalCategoriesCubit>.value(value: cubit, child: child),
  ),
);

void main() {
  late _MockGoalCategoriesCubit cubit;

  setUp(() {
    cubit = _MockGoalCategoriesCubit();
    when(() => cubit.state).thenReturn(const GoalCategoriesState(loaded: true));
    when(() => cubit.stream).thenAnswer((_) => const Stream.empty());
  });

  group('HomeEmptyState §3.9', () {
    testWidgets('renders eyebrow, display title and action button', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(const HomeEmptyState(), cubit: cubit));
      expect(find.textContaining('BLANK SLATE'), findsOneWidget);
      expect(find.textContaining('Your year'), findsOneWidget);
      expect(find.byType(HomeEmptyStateAction), findsOneWidget);
    });

    testWidgets('tapping action button reveals text field §3.9', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(const HomeEmptyState(), cubit: cubit));
      await tester.tap(find.byType(HomeEmptyStateAction));
      await tester.pump();
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('submitting text calls cubit.addPocket §3.9', (tester) async {
      when(() => cubit.addPocket(any())).thenAnswer((_) async {});
      await tester.pumpWidget(_wrap(const HomeEmptyState(), cubit: cubit));
      await tester.tap(find.byType(HomeEmptyStateAction));
      await tester.pump();
      await tester.enterText(find.byType(TextField), 'Work');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      verify(() => cubit.addPocket('Work')).called(1);
    });
  });
}
