import 'package:atelier/presentation/features/detail/detail_container.dart';
import 'package:atelier/presentation/features/home/home_container.dart';
import 'package:go_router/go_router.dart';

class AtelierRouter {
  const AtelierRouter._();

  static GoRouter build() => GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (_, __) => const HomeContainer(),
          ),
          GoRoute(
            path: '/pocket/:id',
            builder: (_, state) {
              final id = state.pathParameters['id']!;
              return DetailContainer(goalCategoryId: id);
            },
          ),
        ],
      );
}
