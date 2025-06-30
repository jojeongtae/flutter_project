import 'package:flutter/material.dart';
import 'package:jomakase/home/home.dart';
import 'package:jomakase/login/login_page.dart';
import 'package:jomakase/public_file/token.dart';
import 'package:jomakase/public_file/userinfo.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context)=> Token() ),
      ChangeNotifierProvider(create: (context) => UserInfo(username: "",password: "",email: "",phone: "",nickname: ""))
    ],
    child: MyApp(),)
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "/": (context) => LoginPage(),
        "/home" : (context) => Home(),
      },
    );
  }
}