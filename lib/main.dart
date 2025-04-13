import 'package:crud_app/screens/home_screen.dart';
import 'package:crud_app/views/database_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:crud_app/firebase_options.dart';

final GlobalKey<ScaffoldState> globalScaffoldKey = GlobalKey();

void main() async {
  // Ensure that the Flutter engine is initialized before running the app
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const SCPApp());
}

class SCPApp extends StatelessWidget {
  // Constructor to accept the database instance
  const SCPApp({super.key});

  static const appTitle = 'SCP Database';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Color(0xff350f0f),
            brightness: Brightness.dark
        ),
        scaffoldBackgroundColor: Color(0xff350f0f)
      ),
      home: MainApp(),
    );
  }
}

class MainApp extends StatefulWidget {
  const MainApp({ super.key });

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static const List<Widget> _pages = <Widget>[
    HomeScreen(),
    DatabaseScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalScaffoldKey,
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onItemTapped,
          destinations: const <NavigationDestination> [
            NavigationDestination(
              selectedIcon: Icon(Icons.home),
              icon: Icon(Icons.home_outlined),
              label: 'Hub',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.dns),
              icon: Icon(Icons.dns_outlined),
              label: 'Directory',
            ),
          ]
      ),
    );
  }
}