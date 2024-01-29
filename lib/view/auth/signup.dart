import 'package:flutter/material.dart';
import 'package:sound_app/view/auth/auth.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AuthScreen(text: 'Register', isLoginScreen: false);
  }
}
