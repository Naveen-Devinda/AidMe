import 'package:aidme/pages/home_page.dart';
import 'package:aidme/pages/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  final bool showMainScreen;

  const Wrapper({super.key, required this.showMainScreen});

  @override
  Widget build(BuildContext context) {
    if (showMainScreen) {
      return const HomePage();
    }
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData) {
          return const HomePage();
        }
        return const LoginPage();
      },
    );
  }
}
