import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jomakase/public_file/layout.dart';
import 'package:jomakase/public_file/world_cup_item.dart';

class Statistics extends StatelessWidget {
  final String? category;

  Statistics({super.key, required this.category});

  // 순위 데이터 받아오기
  Future<List<RankingItem>> fetchRanking(String category) async {
    final url = Uri.parse("http://10.0.2.2:8080/result/${category}_world_cup");
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final List<dynamic> result = json.decode(utf8.decode(res.bodyBytes));
      return result.map((e) => RankingItem.fromJson(e)).toList();
    } else {
      throw Exception("순위 데이터를 불러오지 못했습니다");
    }
  }

  // 댓글 데이터 받아오기
  Future<List<CommentItem>> fetchComments(int winnerid) async {
    final url = Uri.parse(
      "http://10.0.2.2:8080/result/comment?winnerid=$winnerid&winnertype=${category}_world_cup",
    );
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final List<dynamic> result = json.decode(utf8.decode(res.bodyBytes));
      return result.map((e) => CommentItem.fromJson(e)).toList();
    } else {
      throw Exception("댓글 데이터를 불러오지 못했습니다");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Layout2(
      title: "최종 순위표",
      child: FutureBuilder<List<RankingItem>>(
        future: fetchRanking(category!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("에러 발생: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("순위 데이터 없음"));
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
                onTap: () {
                  //댓글창
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: 400,
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${item.name}에 대한 댓글",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(height: 12),
                              Expanded(
                                child: FutureBuilder<List<CommentItem>>(
                                  future: fetchComments(item.id),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else if (snapshot.hasError) {
                                      return Text("에러: ${snapshot.error}");
                                    } else if (!snapshot.hasData ||
                                        snapshot.data!.isEmpty) {
                                      return Text("댓글이 없습니다");
                                    }

                                    final List<dynamic> comments =
                                        snapshot.data!;

                                    return ListView.builder(
                                      itemCount: comments.length,
                                      itemBuilder: (context, index) {
                                        final comment = comments[index];

                                        // playedAt 예: 2025-07-02 10:30:41.123 → 앞부분만 추출
                                        final formattedDate = comment.playedAt
                                            .toString()
                                            .substring(
                                              0,
                                              16,
                                            ); // yyyy-MM-dd HH:mm

                                        return Padding(
                                          padding:  EdgeInsets.only(bottom: 10),
                                          child: ListTile(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                              side:  BorderSide(color: Colors.grey),
                                            ),
                                            leading:  Icon(Icons.person),
                                            subtitle: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                // 닉네임 + 시간 (한 줄에 정렬)
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      comment.username,
                                                      style:  TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    Text(
                                                      formattedDate,
                                                      style:  TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ],
                                                ),

                                                 SizedBox(height: 6),

                                                // 댓글 내용
                                                Text(
                                                  comment.comment,
                                                  style:  TextStyle(fontSize: 15),
                                                ),
                                              ],
                                            ),
                                            contentPadding:  EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 10,
                                            ),
                                          ),
                                        );


                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
