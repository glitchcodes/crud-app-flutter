import 'package:crud_app/screens/home_screen.dart';
import 'package:crud_app/views/database_screen.dart';
import 'package:crud_app/widgets/main_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:crud_app/firebase_options.dart';

import 'app_router.dart';

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
    return MaterialApp.router(
      title: appTitle,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Color(0xff350f0f),
            brightness: Brightness.dark
        ),
        scaffoldBackgroundColor: Color(0xff350f0f)
      ),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}