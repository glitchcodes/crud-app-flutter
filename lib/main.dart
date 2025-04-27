import 'package:crud_app/features/auth/data/data_sources/auth_data_source.dart';
import 'package:crud_app/features/auth/domain/repositories/auth_repository_impl.dart';
import 'package:crud_app/features/auth/domain/usecases/email_password/login_usecase.dart';
import 'package:crud_app/features/auth/domain/usecases/email_password/register_usecase.dart';
import 'package:crud_app/features/auth/domain/usecases/get_current_user.dart';
import 'package:crud_app/features/auth/domain/usecases/logout_user.dart';
import 'package:crud_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:crud_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:crud_app/firebase_options.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_router.dart';

final GlobalKey<ScaffoldState> globalScaffoldKey = GlobalKey();

void main() async {
  // Ensure that the Flutter engine is initialized before running the app
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);

  final authBloc = AuthBloc(
    registerWithEmailAndPassword: RegisterWithEmailAndPassword(
      AuthRepositoryImpl(
        authDataSource: AuthDataSource()
      )
    ),
    loginWithEmailAndPassword: LoginWithEmailAndPassword(
      repository: AuthRepositoryImpl(
        authDataSource: AuthDataSource()
      )
    ),
    getCurrentUser: GetCurrentUser(
      repository: AuthRepositoryImpl(
          authDataSource: AuthDataSource()
      )
    ),
    logoutUser: LogoutUser(
      repository: AuthRepositoryImpl(
          authDataSource: AuthDataSource()
      )
    )
  );

  // Check auth on startup
  authBloc.add(CheckAuthStatusEvent());

  runApp(SCPApp(authBloc: authBloc));
}

class SCPApp extends StatelessWidget {
  final AuthBloc authBloc;

  // Constructor to accept the database instance
  const SCPApp({super.key, required this.authBloc});

  static const appTitle = 'SCP Database';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => authBloc,
      child: MaterialApp.router(
      title: appTitle,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: Color(0xff350f0f),
              brightness: Brightness.dark
          ),
          scaffoldBackgroundColor: Color(0xff350f0f),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF5B6057),
                  foregroundColor: Colors.white
              )
          )
      ),
      routerConfig: AppRouter(authBloc: authBloc).router,
      debugShowCheckedModeBanner: false
      )
    );
  }
}