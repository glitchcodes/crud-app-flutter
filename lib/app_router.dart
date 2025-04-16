import 'package:crud_app/screens/home_screen.dart';
import 'package:crud_app/views/database_screen.dart';
import 'package:crud_app/views/home/home_view.dart';
import 'package:crud_app/widgets/main_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:crud_app/views/home/guide_view.dart';

final router = GoRouter(
  initialLocation: '/hub',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainScaffold(navigationShell: navigationShell);
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