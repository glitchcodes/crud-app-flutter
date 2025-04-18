import 'package:crud_app/ui/typography/text_heading.dart';
import 'package:flutter/material.dart';

import 'package:crud_app/ui/drawer/home_drawer.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  final Widget child;

  const HomeScreen({super.key, required this.child});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedDrawerIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Sync drawer selection when route changes
    final location = GoRouterState.of(context).uri.path;
    final newIndex = HomeDrawer.getSelectedIndex(location);
    if (_selectedDrawerIndex != newIndex) {
      setState(() => _selectedDrawerIndex = newIndex);
    }
  }

  void _handleDrawerItemSelected(int index) {
    setState(() {
      _selectedDrawerIndex = index;
    });

    switch (index) {
      case 0:
        context.go('/hub');
        break;
      case 1:
        context.go('/hub/guide');
        break;
      default:
        context.go('/hub');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              });
          }),
        title: TextHeading(
          text: 'The Hub',
          style: TextStyle(
              fontSize: 24
          ),
          fontName: 'Grenze Gotisch',
        ),
      ),
      drawer: HomeDrawer(
        selectedDrawerIndex: _selectedDrawerIndex,
        onItemSelected: _handleDrawerItemSelected,
      ),
      body: widget.child
    );
  }
}