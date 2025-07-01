import 'package:flutter/material.dart';
import 'package:jomakase/public_file/layout.dart';
import 'package:http/http.dart' as http;

class WorldcupPage extends StatefulWidget {
final String? title;
  const WorldcupPage({super.key,required this.title});

  @override
  State<WorldcupPage> createState() => _WorldcupPageState();
}

class _WorldcupPageState extends State<WorldcupPage> {

  // Future<List<String>> fetchData(String title)async{
  //   final url = Uri.parse("http://10.0.2.2:8080/food/round");
  //   final res = await http.get(url);
  //   if(res.statusCode == 200){
  //     final List<dynamic>
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return  Layout2(
      title: widget.title,
      child: Column(
        children: [
        ],
      ),
    );
  }
}
