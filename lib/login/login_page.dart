import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jomakase/public_file/layout.dart';
import 'package:jomakase/public_file/token.dart';
import 'package:jomakase/public_file/userinfo.dart';
import 'package:provider/provider.dart';
import 'package:jomakase/public_file/api_service.dart'; // ApiService import

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  String? username, password, email, phone, nickname;
  
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<bool> loginRequest() async {
    Token provider = context.read<Token>();
    try {
      final response = await ApiService.login(username!, password!); // ApiService.login 호출
      provider.accessToken = response['token']!;
      provider.refreshToken = response['refresh']!;

      UserInfo userInfo = context.read<UserInfo>();
      userInfo.updateFromJson(response['userInfo']);
      userInfo.token = response['token']!;
      return true;
    } catch (e) {
      _showSnackbar(e.toString().replaceFirst('Exception: ', ''), Colors.red);
    }
    return false;
  }

  Future<bool> signupRequest() async {
    final data = {
      'username': username,
      'password': password,
      'email': email,
      'phone': phone,
      'nickname':nickname
    };

    try {
      await ApiService.signup(data as Map<String, dynamic>); // ApiService.signup 호출
      _showSnackbar("회원가입 성공", Colors.green);
      return true;
    } catch (e) {
      _showSnackbar(e.toString().replaceFirst('Exception: ', ''), Colors.red);
    }
    return false;
  }

  void _trySubmit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_isLogin) {
        loginRequest().then((success) {
          if (success) Navigator.pushReplacementNamed(context, "/home");
        });
      } else {
        signupRequest().then((success) {
          if (success) {
            setState(() => _isLogin = true);
            _controller.forward(from: 0.0);
            _showSnackbar("회원가입 성공! 로그인 해주세요.", Colors.green);
          }
        });
      }
    }
  }

  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    final Color accentColor = Theme.of(context).colorScheme.secondary;

    return Layout(
      title: _isLogin ? "로그인" : "회원가입",
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    _isLogin ? "다시 오신 것을 환영합니다!" : "새로운 계정을 만드세요",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.headlineMedium?.color),
                  ),
                  const SizedBox(height: 40),
                  _buildTextFormField(key: const ValueKey('username'), icon: Icons.person, label: "아이디", onSaved: (val) => username = val),
                  const SizedBox(height: 16),
                  _buildTextFormField(key: const ValueKey('password'), icon: Icons.lock, label: "비밀번호", onSaved: (val) => password = val, obscureText: true),
                  if (!_isLogin) ...[
                    const SizedBox(height: 16),
                    _buildTextFormField(key: const ValueKey('email'), icon: Icons.email, label: "이메일", onSaved: (val) => email = val, keyboardType: TextInputType.emailAddress),
                    const SizedBox(height: 16),
                    _buildTextFormField(key: const ValueKey('phone'), icon: Icons.phone, label: "전화번호", onSaved: (val) => phone = val, keyboardType: TextInputType.phone),
                    const SizedBox(height: 16),
                    _buildTextFormField(key: const ValueKey('nickname'), icon: Icons.face, label: "닉네임", onSaved: (val) => nickname = val),
                  ],
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _trySubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(_isLogin ? "로그인" : "회원가입", style: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.onPrimary)),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      setState(() => _isLogin = !_isLogin);
                      _controller.forward(from: 0.0);
                    },
                    child: Text(
                      _isLogin ? "계정이 없으신가요? 회원가입" : "이미 계정이 있으신가요? 로그인",
                      style: TextStyle(color: accentColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required Key key,
    required IconData icon,
    required String label,
    required FormFieldSetter<String> onSaved,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      key: key,
      onSaved: onSaved,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) return '$label을(를) 입력해주세요.';
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.deepPurple),
        ),
        filled: true,
        fillColor: Theme.of(context).inputDecorationTheme.fillColor ?? Theme.of(context).colorScheme.surface,
      ),
    );
  }
}