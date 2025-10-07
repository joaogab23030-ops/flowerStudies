import 'package:app_flower_studies/view/screens/home_screen.dart';
import 'package:app_flower_studies/view/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class AuthGate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Colors.pinkAccent,
              ),
            ),
          );
        }

        if (snapshot.hasData) {
          return HomeScreen();
        }

        return LoginScreen();
      },
    );
  }
}