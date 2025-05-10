import 'package:crud_app/services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ReauthDialog extends StatefulWidget {
  const ReauthDialog({super.key});
  @override
  State<StatefulWidget> createState() => _ReauthDialogState();
}

class _ReauthDialogState extends State<ReauthDialog> {
  final emailController = TextEditingController();
  String? emailError;
  String? passwordError;
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final FirebaseService firebaseService = FirebaseService();

  Future<bool> handleSubmit() async {
    if (formKey.currentState!.validate()) {
      try {
        // Test email and password
        await firebaseService.reAuthenticateUser(
          emailController.text,
          passwordController.text,
        );

        // Return true if authentication is successful
        return true; // Authentication was successful
      } on FirebaseAuthException catch (e) {
        // Handle known auth errors
        if (e.code == 'user-not-found' || e.code == 'wrong-password') {
          setState(() {
            passwordError = 'Invalid email or password';
          });
        }
      } catch (e) {
        // Handle other exceptions
        setState(() {
          passwordError = 'An error occurred. Please try again.';
        });
      }
    }
    return false; // Authentication failed
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'To proceed, please enter your current email and password.',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                errorText: emailError,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
            ),
            SizedBox(height: 12),
            TextFormField(
              controller: passwordController, // Attached to the password field
              decoration: InputDecoration(
                labelText: 'Password',
                errorText: passwordError,
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        // Cancel button
        TextButton(
          onPressed:
              () => Navigator.pop(context, false), // Pop with false for cancel
          child: Text('Cancel'),
        ),
        // Check button
        ElevatedButton(
          onPressed: () async {
            if (await handleSubmit()) {
              if (mounted && Navigator.canPop(context)) {
                Navigator.pop(context, true);
              }
            } // Only handleSubmit pops the dialog
          },
          child: Text('Check'),
        ),
      ],
    );
  }
}

Future<bool> showReauthDialog(BuildContext context) async {
  bool? result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return ReauthDialog();
    },
  );

  // If result is null, it means dialog was dismissed without action (cancel)
  return result ?? false;
}
