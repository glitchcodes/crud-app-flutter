import 'package:flutter/material.dart';

import 'package:crud_app/ui/typography/text_heading.dart';

class DirectoryDrawer extends StatelessWidget {
  final int selectedDrawerIndex;
  final Function(int) onItemSelected;

  const DirectoryDrawer({
    super.key,
    required this.selectedDrawerIndex,
    required this.onItemSelected
  });

  static const Map<String, int> routeToIndex = {
    '/directory/contribute': 0,
    '/directory': 1,
    '/directory/bookmarks': 2,
    '/directory/search': 3,
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
                  text: 'The Directory',
                  style: TextStyle(
                      fontSize: 24
                  ),
                  fontName: 'Grenze Gotisch',
                ),
              ],
            ),
          ),
          NavigationDrawerDestination(
              icon: Icon(Icons.add_outlined),
              selectedIcon: Icon(Icons.add_rounded),
              label: Text('Contribute')
          ),
          SizedBox(height: 16),
          Padding(
              padding: EdgeInsets.only(
                  left: 16,
                  bottom: 12
              ),
              child: TextHeading(
                  text: 'Database',
                  style: TextStyle(fontSize: 14)
              )
          ),
          NavigationDrawerDestination(
              icon: Icon(Icons.book_outlined),
              selectedIcon: Icon(Icons.book_rounded),
              label: Text('Series')
          ),
          NavigationDrawerDestination(
              icon: Icon(Icons.bookmark_outline),
              selectedIcon: Icon(Icons.bookmark_rounded),
              label: Text('Bookmarks')
          ),
          NavigationDrawerDestination(
              icon: Icon(Icons.search_outlined),
              selectedIcon: Icon(Icons.search_rounded),
              label: Text('Search')
          ),
        ]
    );
  }
}