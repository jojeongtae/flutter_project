import 'package:flutter/material.dart';
import 'package:jomakase/public_file/layout.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Layout(
        title: "음식점 리스트",
        child: Column(
      children: [
        Text("gd"),
      ],
    ));
  }
}
