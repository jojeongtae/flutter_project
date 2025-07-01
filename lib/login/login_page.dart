import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jomakase/public_file/layout.dart';
import 'package:http/http.dart' as http;
import 'package:jomakase/public_file/token.dart';
import 'package:jomakase/public_file/userinfo.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  String? username;
  String? password;
  String? email;
  String? phone;
  String? nickname;

  Future<bool> loginRequest() async {
    Token provider = context.read<Token>();

    final url = Uri.parse("http://10.0.2.2:8080/login");
    final Map<String, String> data = {
      'username': username!,
      'password': password!,
    };
    try {
      final res = await http.post(url, headers: {'Content-Type': 'application/x-www-form-urlencoded'},body: data);
      print(res.statusCode);
      if (res.statusCode == 200) {
        final token = res.headers['authorization'];
        final refresh = res.headers['set-cookie'];
        provider.accessToken = token!;
        provider.refreshToken = refresh!;

        UserInfo userInfo = context.read<UserInfo>();
        userInfo.updateFromJson(json.decode(utf8.decode(res.bodyBytes)));
        return true;
      } else if (res.statusCode == 401) {
        final msg = json.decode(utf8.decode(res.bodyBytes));
        loginSnackBar(context, msg['error']);
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<bool> signupRequest() async {
    final url = Uri.parse("http://10.0.2.2:8080/join");
    final data = {
      'username': username,
      'password': password,
      'email': email,
      'phone': phone,
      'nickname':nickname
    };

    try {
      final res = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (res.statusCode == 200) {
        loginSnackBar(context, "회원가입 성공");
        return true;
      } else {
        final msg = json.decode(utf8.decode(res.bodyBytes));
        loginSnackBar(context, msg['error']);
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  bool tryValidation() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: _isLogin ? "로그인 페이지" : "회원가입 페이지",
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isLogin = true;
                  });
                },
                child: Text("로그인", style: TextStyle(fontSize: 18, fontWeight: _isLogin ? FontWeight.bold : FontWeight.normal)),
              ),
              SizedBox(width: 20),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isLogin = false;
                  });
                },
                child: Text("회원가입", style: TextStyle(fontSize: 18, fontWeight: !_isLogin ? FontWeight.bold : FontWeight.normal)),
              ),
            ],
          ),
          SizedBox(height: 20),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  key: ValueKey(1),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "no text";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    username = value!;
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.abc_outlined, color: Colors.grey[400]),
                    hintText: "아이디 입력 칸",
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  key: ValueKey(2),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "no password";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    password = value!;
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock, color: Colors.grey[400]),
                    hintText: "비밀번호 입력 칸",
                  ),
                ),
                if (!_isLogin) ...[
                  SizedBox(height: 20),
                  TextFormField(
                    key: ValueKey(3),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "no email";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      email = value!;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email, color: Colors.grey[400]),
                      hintText: "이메일 입력 칸",
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    key: ValueKey(4),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "no phone";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      phone = value!;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.phone, color: Colors.grey[400]),
                      hintText: "핸드폰 번호 입력 칸",
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    key: ValueKey(5),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "no nickname";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      nickname = value!;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.account_circle, color: Colors.grey[400]),
                      hintText: "닉네임 입력 칸",
                    ),
                  ),
                ],
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () {
                    if (tryValidation()) {
                      if (_isLogin) {
                        loginRequest().then((data) {
                          if (data) {
                            Navigator.pushNamed(context, "/home");
                          }
                        });
                      } else {
                        signupRequest().then((success) {
                          if (success) {
                            _isLogin = true;
                            loginSnackBar(context, "회원가입 성공");
                          } else {
                            loginSnackBar(context, "회원가입 실패");
                          }
                        });
                      }
                    }
                  },
                  child: Text(_isLogin ? "로그인" : "회원가입", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void loginSnackBar(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(msg, textAlign: TextAlign.center),
      duration: Duration(seconds: 2),
      backgroundColor: Colors.green,
    ),
  );
}
