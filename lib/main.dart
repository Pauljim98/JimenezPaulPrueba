import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username or email',
                ),
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _onLoginPressed();
                },
                child: Text('Login'),
              ),
              TextButton(
                onPressed: () {
                  _onRegisterPressed();
                },
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onLoginPressed() {
    final username = _usernameController.text;
    final password = _passwordController.text;

    // Implement logic to authenticate the user

    // For example, you could check if the username and password are stored in a local database.

    if (username == 'admin' && password == 'password') {
      // Login successful

      _navigateToHomeScreen();
    } else {
      // Login failed

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login failed'),
        ),
      );
    }
  }

  void _onRegisterPressed() {
    // Navigate to the registration screen

    Navigator.of(context).pushNamed('/register');
  }

  void _navigateToHomeScreen() {
    // Navigate to the home screen

    Navigator.of(context).pushNamed('/home');
  }
}