import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'login_page.dart';
import 'main_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return StreamBuilder(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        final session = snapshot.data?.session ??
            authService.currentSession;

        if (session == null) {
          return const LoginPage();
        }

        return const MainPage();
      },
    );
  }
}
