import 'package:crud_app/views/database_screen.dart';
import 'package:crud_app/views/home_screen.dart';
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
    HomeScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalScaffoldKey,
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Hub'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.dns),
              label: 'Directory'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile'
          )
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}