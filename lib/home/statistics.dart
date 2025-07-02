import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jomakase/public_file/layout.dart';
import 'package:jomakase/public_file/world_cup_item.dart';

class Statistics extends StatelessWidget {
  final String? category;

  Statistics({super.key, required this.category});

  Future<List<RankingItem>> fetchRanking(String category) async {
    final url = Uri.parse("http://10.0.2.2:8080/result/${category}_world_cup"); // ← category 활용
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final List<dynamic> result = json.decode(utf8.decode(res.bodyBytes));
      return result.map((e) => RankingItem.fromJson(e)).toList();
    } else {
      throw Exception("순위 데이터를 불러오지 못했습니다");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Layout2(
      title: "최종 순위표",
      child: FutureBuilder<List<RankingItem>>(
        future: fetchRanking(category!), // ← 예시
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text("에러 발생: ${snapshot.error}");
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text("순위 데이터 없음");
          }

          final rankings = snapshot.data!;
          return ListView.builder(
            itemCount: rankings.length,
            itemBuilder: (context, index) {
              final item = rankings[index];
              return ListTile(
                leading: Text("${index + 1}위"),
                title: Text(item.name),
                subtitle: Text("선택된 횟수: ${item.count}"),
                trailing: Image.network(item.imageurl, width: 60, height: 60),
              );
            },
          );
        },
      )


    );
  }
}
