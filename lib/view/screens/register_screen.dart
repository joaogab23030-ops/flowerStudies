import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:app_flower_studies/view/widgets/circle_custom.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();

  final double baseDip = 0.40;
  final double waveAmplitude = 20.0;
  bool _isButtonEnabled = false;
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
    _passwordController.dispose();
    super.dispose();
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
    if (value.length <= 4) return 'A senha tem que ter mais de 4 caracteres';
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

  void _updateButtonState() {
    if (formKey.currentState == null) return;
    final bool isValid = formKey.currentState!.validate();
    if (isValid != _isButtonEnabled) {
      setState(() {
        _isButtonEnabled = isValid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final String fontGlobal = 'DeliusSwashCaps';

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          // Fundo animado
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
          // Formulário
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                top: screenHeight * baseDip + waveAmplitude - 50,
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
                    key: formKey,
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
                          decoration: InputDecoration(
                            labelText: 'E-mail',
                            hintText: 'exemplo@gmail.com',
                            hintStyle: TextStyle(
                              color: Colors.black.withOpacity(0.25),
                            ),
                          ),
                          validator: validatorEmail,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (_) => _updateButtonState(),
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
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                          ),
                          obscureText: !_isPasswordVisible,
                          validator: validatorPassword,
                          onChanged: (_) => _updateButtonState(),
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Confirmar Senha',
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isConfirmPasswordVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isConfirmPasswordVisible =
                                      !_isConfirmPasswordVisible;
                                });
                              },
                            ),
                          ),
                          obscureText: !_isConfirmPasswordVisible,
                          validator: validatorConfirmPassword,
                          onChanged: (_) => _updateButtonState(),
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Nome do usuário',
                          ),
                          validator: validatorNome,
                          onChanged: (_) => _updateButtonState(),
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Idade'),
                          keyboardType: TextInputType.number,
                          validator: validatorIdade,
                          onChanged: (_) => _updateButtonState(),
                        ),
                        SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: _isButtonEnabled
                              ? () {
                                  print("Formulário válido! Registrando...");
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isButtonEnabled
                                ? Colors.pinkAccent
                                : Colors.grey,
                            padding: EdgeInsets.symmetric(
                              horizontal: 50,
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Registrar',
                            style: TextStyle(fontSize: 18, color: Colors.white),
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
