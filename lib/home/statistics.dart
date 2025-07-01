import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jomakase/public_file/layout.dart';
import 'package:jomakase/public_file/world_cup_item.dart';
import 'package:http/http.dart' as http;

class Statistics extends StatelessWidget {
String? category;
  Statistics({super.key, required this.category});

// Future <List<WorldcupItem>> fetchData() async{
//   final url = Uri.parse("http://10.0.2.2:8080/result/${category}_world_cup");
//   final res = await http.get(url);
//   if(res.statusCode == 200){
//     final List<dynamic> result = json.decode(utf8.decode(res.bodyBytes));
//   }
// }
  @override
  Widget build(BuildContext context) {
    return Layout2(
      child: Center(
        child: Column(
          children: [

          ],
        ),
      ),
    );
  }
}
