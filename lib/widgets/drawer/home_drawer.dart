import 'package:flutter/material.dart';

import 'package:crud_app/widgets/typography/text_heading.dart';

class HomeDrawer extends StatelessWidget {
  final String currentRoute;
  final Function(String) onDestinationSelected;

  const HomeDrawer({
    super.key,
    required this.currentRoute,
    required this.onDestinationSelected
  });

  int _routeToIndex(String route) {
    switch (route) {
      case '/home':
        return 0;
      case '/guide':
        return 1;
      case '/contribute':
        return 2;
      case '/faq':
        return 3;
      case '/universe-hub':
        return 4;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
      selectedIndex: _routeToIndex(currentRoute),
      onDestinationSelected: (index) {
        final routes = [
          '/home',
          '/guide',
          '/contribute',
          '/faq',
          '/universe-hub'
        ];
        onDestinationSelected(routes[index]);
      },
      children: const [
        Padding(padding: EdgeInsets.all(16),
          child: Column(
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
        ),
        SizedBox(height: 16),
        Padding(
            padding: EdgeInsets.only(
              left: 16,
              bottom: 12
            ),
            child: TextHeading(
                text: 'Getting Started',
                style: TextStyle(fontSize: 14)
            )
        ),
        NavigationDrawerDestination(
            icon: Icon(Icons.book_outlined),
            selectedIcon: Icon(Icons.book_rounded),
            label: Text('Guide for Newcomers')
        ),
        NavigationDrawerDestination(
            icon: Icon(Icons.accessibility_new_outlined),
            selectedIcon: Icon(Icons.accessibility_new_rounded),
            label: Text('Contribute')
        ),
        NavigationDrawerDestination(
            icon: Icon(Icons.quiz_outlined),
            selectedIcon: Icon(Icons.quiz_rounded),
            label: Text('FAQ')
        ),
        NavigationDrawerDestination(
            icon: Icon(Icons.forum_outlined),
            selectedIcon: Icon(Icons.forum_rounded),
            label: Text('Universe Hub')
        )
      ]
    );
  }
}