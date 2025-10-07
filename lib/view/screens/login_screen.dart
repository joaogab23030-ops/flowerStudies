import 'dart:math' as math;
import 'package:app_flower_studies/repository/firebase_servise.dart';
import 'package:app_flower_studies/view/widgets/circle_custom.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  final double baseDip = 0.40;
  final double waveAmplitude = 20.0;
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    )..repeat();
    _animation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      try {
        await _authService.signInWithEmailAndPassword(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
      } on FirebaseAuthException catch (e) {
        String message = 'Ocorreu um erro.';
        if (e.code == 'user-not-found' || e.code == 'wrong-password' || e.code == 'invalid-credential') {
          message = 'E-mail ou senha incorretos.';
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message), backgroundColor: Colors.red),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  String? validatorPassword(String? value) {
    if (value == null || value.isEmpty) return 'É preciso inserir a senha';
    return null;
  }

  String? validatorEmail(String? value) {
    if (value == null || value.isEmpty) return 'É preciso inserir um e-mail';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final String fontGlobal = 'DeliusSwashCaps';

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              double currentDip = screenHeight * baseDip +
                  (waveAmplitude * math.sin(_animation.value * 2 * math.pi));
              return Stack(
                children: [
                  CustomPaint(
                    size: Size(double.infinity, screenHeight),
                    painter: WavePainter(_animation.value),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    top: currentDip / 2.5,
                    child: Center(
                      child: Text('Flower Studies',
                          style: TextStyle(
                              fontFamily: fontGlobal,
                              fontSize: 28,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              );
            },
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  top: screenHeight * baseDip + waveAmplitude - 20,
                  bottom: 40),
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(24),
                  width: 340,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: Offset(4, 4))
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Login",
                            style: TextStyle(
                                fontSize: 24,
                                color: Colors.black87,
                                fontFamily: fontGlobal)),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(labelText: 'E-mail'),
                          validator: validatorEmail,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Senha',
                            suffixIcon: IconButton(
                              icon: Icon(_isPasswordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () => setState(
                                  () => _isPasswordVisible = !_isPasswordVisible),
                            ),
                          ),
                          obscureText: !_isPasswordVisible,
                          validator: validatorPassword,
                        ),
                        SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: _isLoading ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pinkAccent,
                            padding: EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: _isLoading
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                      color: Colors.white, strokeWidth: 3))
                              : Text('Entrar',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white)),
                        ),
                        SizedBox(height: 20),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => RegisterScreen()),
                            );
                          },
                          child: Text(
                            'Não tem uma conta? Registre-se',
                            style: TextStyle(color: Colors.pinkAccent),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}