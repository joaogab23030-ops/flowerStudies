import 'dart:math' as math;
import 'package:app_flower_studies/repository/firebase_servise.dart';
import 'package:app_flower_studies/view/widgets/circle_custom.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final AuthService _authService = AuthService();
  final DatabaseService _databaseService = DatabaseService();

  final double baseDip = 0.40;
  final double waveAmplitude = 20.0;
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    )..repeat();
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      try {
        User? user = await _authService.registerWithEmailAndPassword(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );

        if (user != null) {
          await _databaseService.saveUserData(
            uid: user.uid,
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            age: int.parse(_ageController.text.trim()),
          );

          if (!mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Registro realizado com sucesso! Faça o login.'),
              backgroundColor: Colors.green,
            ),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        }
      } on FirebaseAuthException catch (e) {
        String message = 'Ocorreu um erro.';
        if (e.code == 'email-already-in-use') {
          message = 'Este e-mail já está em uso.';
        } else if (e.code == 'weak-password') {
          message = 'A senha fornecida é muito fraca.';
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message), backgroundColor: Colors.red),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Ocorreu um erro desconhecido.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  String? validatorNome(String? value) {
    if (value == null || value.isEmpty) return 'É preciso inserir o nome';
    if (value.length < 2) return 'O nome deve ter pelo menos 2 caracteres';
    return null;
  }

  String? validatorIdade(String? value) {
    if (value == null || value.isEmpty) return 'É preciso inserir a idade';
    final idade = int.tryParse(value);
    if (idade == null || idade <= 0) return 'Insira uma idade válida';
    return null;
  }

  String? validatorPassword(String? value) {
    if (value == null || value.isEmpty) return 'É preciso inserir uma senha';
    if (value.contains(' ')) return 'Não pode conter espaços';
    if (value.length < 6) return 'A senha deve ter no mínimo 6 caracteres';
    return null;
  }

  String? validatorConfirmPassword(String? value) {
    if (value == null || value.isEmpty) return 'É preciso confirmar a senha';
    if (value != _passwordController.text) return 'As senhas não coincidem';
    return null;
  }

  String? validatorEmail(String? value) {
    if (value == null || value.isEmpty) return 'É preciso inserir um e-mail';
    final emailRegExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    );
    if (!emailRegExp.hasMatch(value))
      return 'Insira um formato de e-mail válido';
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
              double currentDip =
                  screenHeight * baseDip +
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
                      child: Text(
                        'Flower Studies',
                        style: TextStyle(
                          fontFamily: fontGlobal,
                          fontSize: 28,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                top: screenHeight * baseDip + waveAmplitude - 50,
                bottom: 40,
              ),
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
                        offset: Offset(4, 4),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Registre-se",
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.black87,
                            fontFamily: fontGlobal,
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'E-mail',
                            hintText: 'exemplo@gmail.com',
                          ),
                          validator: validatorEmail,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Senha',
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () => setState(
                                () => _isPasswordVisible = !_isPasswordVisible,
                              ),
                            ),
                          ),
                          obscureText: !_isPasswordVisible,
                          validator: validatorPassword,
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _confirmPasswordController,
                          decoration: InputDecoration(
                            labelText: 'Confirmar Senha',
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isConfirmPasswordVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () => setState(
                                () => _isConfirmPasswordVisible =
                                    !_isConfirmPasswordVisible,
                              ),
                            ),
                          ),
                          obscureText: !_isConfirmPasswordVisible,
                          validator: validatorConfirmPassword,
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Nome do usuário',
                          ),
                          validator: validatorNome,
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _ageController,
                          decoration: InputDecoration(labelText: 'Idade'),
                          keyboardType: TextInputType.number,
                          validator: validatorIdade,
                        ),
                        SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: _isLoading ? null : _handleRegister,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pinkAccent,
                            padding: EdgeInsets.symmetric(
                              horizontal: 50,
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isLoading
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
                                  ),
                                )
                              : Text(
                                  'Registrar',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                        SizedBox(height: 20),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'Já tem uma conta? Faça o login',
                            style: TextStyle(color: Colors.pinkAccent),
                          ),
                        ),
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
