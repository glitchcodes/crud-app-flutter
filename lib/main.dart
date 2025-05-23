import 'package:crud_app/features/auth/data/data_sources/auth_data_source.dart';
import 'package:crud_app/features/auth/domain/repositories/auth_repository_impl.dart';
import 'package:crud_app/features/auth/domain/usecases/email_password/login_usecase.dart';
import 'package:crud_app/features/auth/domain/usecases/email_password/register_usecase.dart';
import 'package:crud_app/features/auth/domain/usecases/get_current_user.dart';
import 'package:crud_app/features/auth/domain/usecases/logout_user.dart';
import 'package:crud_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:crud_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:crud_app/features/directory/presentation/bloc/directory_bloc.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:crud_app/firebase_options.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app_router.dart';

final GlobalKey<ScaffoldState> globalScaffoldKey = GlobalKey();

void main() async {
  // Ensure that the Flutter engine is initialized before running the app
  WidgetsFlutterBinding.ensureInitialized();

  // Load .env
  await dotenv.load(fileName: '.env');

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

  final directoryBloc = DirectoryBloc();

  // Check auth on startup
  authBloc.add(CheckAuthStatusEvent());

  runApp(SCPApp(authBloc: authBloc, directoryBloc: directoryBloc));
}

class SCPApp extends StatelessWidget {
  final AuthBloc authBloc;
  final DirectoryBloc directoryBloc;

  // Constructor to accept the database instance
  SCPApp({super.key, required this.authBloc, required this.directoryBloc});

  static const appTitle = 'SCP Database';

  late final _router = AppRouter(authBloc: authBloc).router;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => authBloc),
        BlocProvider(create: (context) => directoryBloc)
      ],
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
          routeInformationParser: _router.routeInformationParser,
          routeInformationProvider: _router.routeInformationProvider,
          routerDelegate: _router.routerDelegate,
          debugShowCheckedModeBanner: false,

      )
    );
  }
}