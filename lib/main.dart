import 'package:app_flower_studies/auth_gate.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flower Studies',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        inputDecorationTheme: InputDecorationTheme(
          border: UnderlineInputBorder(),
        )
      ),
      home: AuthGate(),
    );
  }
}