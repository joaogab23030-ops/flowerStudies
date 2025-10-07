import 'package:app_flower_studies/repository/firebase_servise.dart';
import 'package:flutter/material.dart';


class HomeScreen extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Página Inicial'),
        backgroundColor: Colors.pinkAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await _authService.signOut();
            },
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Login realizado com sucesso!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}