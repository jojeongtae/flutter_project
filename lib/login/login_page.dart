import 'package:flutter/material.dart';
import 'package:jomakase/public_file/layout.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  String? username = null;
  String? password = null;
  String? email = null;
  String? phone = null;

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
                child: Text(
                  "로그인",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: _isLogin ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
              SizedBox(width: 20),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isLogin = false;
                  });
                },
                child: Text(
                  "회원가입",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: !_isLogin ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
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
                  validator: (value){
                    if(!value!.isEmpty){
                      return "no text";
                    }
                  },
                  onSaved: (value){
                    username = value!;
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.account_circle,
                      color: Colors.grey[400],
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.deepPurpleAccent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.orangeAccent),
                    ),
                    hintText: "아이디 입력 칸",
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  key: ValueKey(2),
                  validator: (value){
                    if(value!.isEmpty){
                      return "no password";
                    }
                  },
                  onSaved: (value){
                    password = value!;
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock, color: Colors.grey[400]),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.deepPurpleAccent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.orangeAccent),
                    ),
                    hintText: "비밀번호 입력 칸",
                  ),
                ),
                SizedBox(height: 20),
                if (!_isLogin) ...[
                  SizedBox(height: 20),
                  TextFormField(
                    key: ValueKey(3),
                    validator: (value){
                      if(value!.isEmpty){
                        return "no email";
                      }
                    },
                    onSaved: (value){
                      email = value!;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.email,
                        color: Colors.grey[400],
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Colors.deepPurpleAccent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Colors.orangeAccent),
                      ),
                      hintText: "이메일 입력 칸",
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    key: ValueKey(4),
                    onSaved: (value){
                      phone = value!;
                    },
                    validator: (value){
                      if(value!.isEmpty){
                        return "no phone";
                      }
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.phone_android,
                        color: Colors.grey[400],
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Colors.deepPurpleAccent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Colors.orangeAccent),
                      ),
                      hintText: "핸드폰 번호 입력 칸",
                    ),
                  ),
                ],
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,

                  ),
                  onPressed: () {},
                  child: Text(_isLogin ? "로그인" : "회원가입",style: TextStyle(
                    color: Colors.white,
                  ),),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}