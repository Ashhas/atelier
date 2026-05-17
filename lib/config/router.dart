import 'package:atelier/presentation/features/detail/detail_container.dart';
import 'package:atelier/presentation/features/focus/focus_container.dart';
import 'package:atelier/presentation/features/home/home_container.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class AtelierRouter {
  const AtelierRouter._();

  static GoRouter build() => GoRouter(
    routes: [
      GoRoute(path: '/', builder: (_, __) => const HomeContainer()),
      GoRoute(
        path: '/focus',
        pageBuilder: (_, __) => CustomTransitionPage(
          child: const FocusContainer(),
          // Brief slide-up + fade. Subtle enough not to compete with
          // the in-screen stagger (header/cards/rest), but present
          // enough to read as "a new view arrived" rather than a
          // jumpcut. ~260ms matches the design's header timing.
          transitionDuration: const Duration(milliseconds: 260),
          reverseTransitionDuration: const Duration(milliseconds: 200),
          transitionsBuilder: (_, animation, __, child) {
            final eased = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
              reverseCurve: Curves.easeInCubic,
            );
            return FadeTransition(
              opacity: eased,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.04),
                  end: Offset.zero,
                ).animate(eased),
                child: child,
              ),
            );
          },
        ),
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
