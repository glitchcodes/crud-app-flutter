import 'package:crud_app/widgets/typography/text_heading.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextHeading(
                        text: 'SCP Foundation',
                        style: TextStyle(
                            fontSize: 16
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextHeading(
                        text: 'The Directory',
                        style: TextStyle(
                            fontSize: 30
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
            text: 'Register',
            style: TextStyle(
                fontSize: 20
            ),
          ),
          SizedBox(height: 10),
          Text(
            'All foundation staff must have records stored in the database',
            style: TextStyle(
              fontSize: 16
            ),
          ),
          SizedBox(height: 40),
          RegisterForm()
        ],
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _rememberMe = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logging in...'))
      );

      // Dummy
      await Future.delayed(Duration(seconds: 2));

      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Full Name',
              hintText: 'John Doe',
              floatingLabelBehavior: FloatingLabelBehavior.always,
              prefixIcon: Icon(Icons.person),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
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
                return 'This field is required';
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
          SizedBox(height: 20),
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Confirm Password',
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
          SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _submitForm,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isSubmitting ?
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(color: Colors.white),
              ) :
              Text('Register'),
            ),
          ),
          SizedBox(height: 16),
          TextButton(
            onPressed: () {
              context.go('/login');
            },
            child: Text("Already have an account? Sign In"),
          ),
        ],
      )
    );
  }
}