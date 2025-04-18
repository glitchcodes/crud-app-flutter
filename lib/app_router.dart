import 'package:crud_app/util/page_transitions.dart';
import 'package:crud_app/views/auth/login_view.dart';
import 'package:crud_app/views/auth/register_view.dart';
import 'package:go_router/go_router.dart';

import 'package:crud_app/ui/layouts/main_layout.dart';
import 'package:crud_app/ui/layouts/auth_layout.dart';
import 'package:crud_app/ui/screens/home_screen.dart';
import 'package:crud_app/ui/screens/database_screen.dart';
import 'package:crud_app/views/home/home_view.dart';

import 'package:crud_app/views/home/guide_view.dart';

final router = GoRouter(
  initialLocation: '/login',
  routes: [
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