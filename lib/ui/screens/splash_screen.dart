import 'package:crud_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:crud_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:crud_app/ui/typography/text_heading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      final authState = context.read<AuthBloc>().state;

      if (authState is Authenticated) {
        context.go('/hub');
      } else {
        context.go('/login');
      }
    });

    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextHeading(
              text: 'SCP Foundation',
              style: TextStyle(
                  fontSize: 14
              ),
            ),
            TextHeading(
              text: 'The Directory',
              style: TextStyle(
                  fontSize: 24
              ),
              fontName: 'Grenze Gotisch',
            ),
            SizedBox(height: 20),
            CircularProgressIndicator()
          ],
        ),
      ),
    );

  }
}