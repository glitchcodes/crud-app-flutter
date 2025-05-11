import 'package:crud_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:crud_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:crud_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:crud_app/ui/typography/text_heading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextHeading(
                        text: 'SCP Foundation',
                        style: TextStyle(
                            fontSize: 14
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextHeading(
                        text: 'The Directory',
                        style: TextStyle(
                            fontSize: 24
                        ),
                        fontName: 'Grenze Gotisch',
                      ),
                    )
                  ],
                )
              ),
              Spacer(),
              Image.asset(
                'assets/images/scp-logo.png',
                width: 60,
                height: 60,
              )
            ],
          ),
          SizedBox(height: 40),
          TextHeading(
            text: 'Sign In',
            style: TextStyle(
                fontSize: 20
            ),
          ),
          SizedBox(height: 10),
          Text(
            'The following area is restricted access. Please provide identification to gain access.',
            style: TextStyle(
              fontSize: 16
            ),
          ),
          SizedBox(height: 40),
          LoginForm()
        ],
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(LoginEvent(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim()
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Redirecting...'))
          );
        }
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message))
          );
        }
      },
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'johndoe@gmail.com',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  prefixIcon: Icon(Icons.mail),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: state is AuthLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: state is AuthLoading ?
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(color: Colors.white),
                  ) :
                  Text('Sign In'),
                ),
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  context.go('/register');
                },
                child: Text("Don't have an account? Sign Up"),
              ),
            ],
          )
        );
      }
    );
  }
}