import 'package:crud_app/navigation/home_navigator.dart';
import 'package:crud_app/widgets/drawer/home_drawer.dart';
import 'package:crud_app/widgets/object_class_categories.dart';
import 'package:crud_app/widgets/recent_scp_list.dart';
import 'package:crud_app/widgets/typography/text_heading.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  String _currentRoute = '/home';

  void _navigateTo(String route) {
    if (_currentRoute == route) return;

    _navigatorKey.currentState!.pushReplacementNamed(route);

    setState(() {
      _currentRoute = route;
    });
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
        currentRoute: _currentRoute,
        onDestinationSelected: _navigateTo
      ),
      body: HomeNavigator(navigatorKey: _navigatorKey)
    );
  }
}