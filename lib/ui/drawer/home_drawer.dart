import 'package:flutter/material.dart';

import 'package:crud_app/ui/typography/text_heading.dart';

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
          NavigationDrawerDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded),
              label: Text('Home')
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