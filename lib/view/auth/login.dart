import 'package:flutter/material.dart';
import 'package:sound_app/view/auth/auth.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AuthScreen(text: 'Login', isLoginScreen: true);
  }
}
