import 'package:crud_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:crud_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:crud_app/ui/profile_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:crud_app/ui/typography/text_heading.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeDrawer extends StatelessWidget {
  final int selectedDrawerIndex;
  final Function(int) onItemSelected;

  const HomeDrawer({
    super.key,
    required this.selectedDrawerIndex,
    required this.onItemSelected
  });

  static const Map<String, int> routeToIndex = {
    '/hub': 0,
    '/hub/guide': 1,
    '/hub/contribute': 2,
    '/hub/faq': 3,
    '/hub/universe-hub': 4
  };

  static int getSelectedIndex(String route) {
    return routeToIndex[route] ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
        selectedIndex: selectedDrawerIndex,
        onDestinationSelected: (index) {
          onItemSelected(index);
          Navigator.of(context).pop();
        },
        children: [
          Padding(padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextHeading(
                      text: 'SCP Foundation',
                      style: TextStyle(
                          fontSize: 12
                      ),
                    ),
                    TextHeading(
                      text: 'The Hub',
                      style: TextStyle(
                          fontSize: 24
                      ),
                      fontName: 'Grenze Gotisch',
                    ),
                  ],
                ),
                Spacer(),
                IconButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(LogoutEvent());

                      context.go('/login');
                    },
                    icon: Icon(Icons.logout),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[300]
                    ),
                ),
              ],
            )
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: ProfileCard()
          ),
          SizedBox(height: 16),
          const NavigationDrawerDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded),
              label: Text('Home')
          ),
          const SizedBox(height: 16),
          const Padding(
              padding: EdgeInsets.only(
                  left: 16,
                  bottom: 12
              ),
              child: TextHeading(
                  text: 'Getting Started',
                  style: TextStyle(fontSize: 14)
              )
          ),
          const NavigationDrawerDestination(
              icon: Icon(Icons.book_outlined),
              selectedIcon: Icon(Icons.book_rounded),
              label: Text('Guide for Newcomers')
          ),
          const NavigationDrawerDestination(
              icon: Icon(Icons.accessibility_new_outlined),
              selectedIcon: Icon(Icons.accessibility_new_rounded),
              label: Text('Contribute')
          ),
          const NavigationDrawerDestination(
              icon: Icon(Icons.quiz_outlined),
              selectedIcon: Icon(Icons.quiz_rounded),
              label: Text('FAQ')
          ),
          const NavigationDrawerDestination(
              icon: Icon(Icons.forum_outlined),
              selectedIcon: Icon(Icons.forum_rounded),
              label: Text('Universe Hub')
          ),
        ]
    );
  }
}