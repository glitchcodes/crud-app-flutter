import 'dart:async';

import 'package:crud_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:crud_app/ui/screens/splash_screen.dart';
import 'package:crud_app/util/page_transitions.dart';
import 'package:crud_app/views/auth/login_view.dart';
import 'package:crud_app/views/auth/register_view.dart';
import 'package:crud_app/views/home/contribute_view.dart';
import 'package:crud_app/views/home/faq_view.dart';
import 'package:crud_app/views/home/universe_hub_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:crud_app/ui/layouts/main_layout.dart';
import 'package:crud_app/ui/layouts/auth_layout.dart';
import 'package:crud_app/ui/screens/home_screen.dart';
import 'package:crud_app/ui/screens/database_screen.dart';
import 'package:crud_app/views/home/home_view.dart';

import 'package:crud_app/views/home/guide_view.dart';

import 'features/auth/presentation/bloc/auth_bloc.dart';

class AppRouter {
  final AuthBloc authBloc;

  AppRouter({required this.authBloc});

  late final router = GoRouter(
    refreshListenable: _AuthStreamNotifier(authBloc.stream),
    debugLogDiagnostics: true,
    redirect: (BuildContext context, GoRouterState state) async {
      final authState = authBloc.state;
      final currentPath = state.uri.path;

      final authRoutes = [];
      final isAuthenticated = authState is Authenticated;

      if (authState is AuthLoading) return null;

      if (!isAuthenticated && authRoutes.contains(currentPath)) {
        return '/login';
      }

      if (isAuthenticated && (currentPath == '/login' || currentPath == '/register')) {
        return '/hub';
      }

      return null;
    },
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      ShellRoute(
        pageBuilder: (context, state, child) => slideFromRight(
          context: context,
          state: state,
          child: AuthLayout(child: child),
        ),
        routes: [
          GoRoute(
            path: '/login',
            pageBuilder: (context, state) => slideFromRight(
              context: context,
              state: state,
              child: const LoginView(),
            ),
          ),
          GoRoute(
            path: '/register',
            pageBuilder: (context, state) => slideFromRight(
              context: context,
              state: state,
              child: const RegisterView(),
            ),
          ),
        ]
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainLayout(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
              routes: [
                ShellRoute(
                    builder: (context, state, child) {
                      return HomeScreen(child: child);
                    },
                    routes: [
                      GoRoute(
                          path: '/hub',
                          builder: (context, state) => const HomeView(),
                          routes: [
                            GoRoute(
                              path: '/guide',
                              builder: (context, state) => const GuideView(),
                            ),
                            GoRoute(
                              path: '/contribute',
                              builder: (context, state) => const ContributeView(),
                            ),
                            GoRoute(
                              path: '/faq',
                              builder: (context, state) => const FaqView(),
                            ),
                            GoRoute(
                              path: '/universe-hub',
                              builder: (context, state) => const UniverseHubView(),
                            ),
                          ]
                      ),
                      // GoRoute(
                      //   path: 'guide',
                      //   builder: (context, state) => const GuideView(),
                      // ),
                    ]
                ),
              ]
          ),
          StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/directory',
                  builder: (context, state) => const DatabaseScreen(),
                )
              ]
          )
        ]
      )
    ]
  );
}

class _AuthStreamNotifier extends ChangeNotifier {
  _AuthStreamNotifier(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}