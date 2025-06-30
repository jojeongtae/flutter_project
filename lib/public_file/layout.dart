import 'package:flutter/material.dart';

class Layout extends StatelessWidget {
  final Widget? child;
  final String? title;
  const Layout({super.key,required this.child,this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? "",style: TextStyle(
            color: Colors.white
        ),),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: child,
    );
  }
}
class Layout2 extends StatelessWidget {
  const Layout2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
