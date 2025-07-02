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
                // ✅ leading: 순위 + 이미지
                leading: SizedBox(
                  width: 80, // 넉넉한 너비 확보
                  child: Row(
                    children: [
                      Text(
                        "${index + 1}위",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.network(
                          item.imageurl,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),

                // ✅ title: 음식 이름
                title: Text(
                  item.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),

                // ✅ subtitle: 선택된 횟수
                subtitle: Text(
                  "선택된 횟수: ${item.count}",
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),

                // ✅ trailing: 직접 쓰실 예정 → 일단 비워둠
                trailing: SizedBox(
                width: 80,
                height: 10,
                child: LinearProgressIndicator(
                  value: item.rating, // 예: 승률
                  backgroundColor: Colors.grey.shade300,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                ),
              ),

                // ✅ onTap: 댓글 다이얼로그
                onTap: () {
                  // 기존 댓글 다이얼로그 열기
                  showDialog(
                    context: context,
                    builder: (context) {
                      // 그대로 유지
                      return Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: 400,
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${item.name}에 대한 댓글",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Expanded(
                                child: FutureBuilder<List<CommentItem>>(
                                  future: fetchComments(item.id),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return const Center(child: CircularProgressIndicator());
                                    } else if (snapshot.hasError) {
                                      return Text("에러: ${snapshot.error}");
                                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                      return const Text("댓글이 없습니다");
                                    }

                                    final comments = snapshot.data!;
                                    return ListView.builder(
                                      itemCount: comments.length,
                                      itemBuilder: (context, index) {
                                        final comment = comments[index];
                                        final formattedDate = comment.playedAt.toString().substring(0, 16);

                                        return Padding(
                                          padding: const EdgeInsets.only(bottom: 10),
                                          child: ListTile(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                              side: const BorderSide(color: Colors.grey),
                                            ),
                                            leading: const Icon(Icons.person),
                                            subtitle: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      comment.username,
                                                      style: const TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    Text(
                                                      formattedDate,
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 6),
                                                Text(
                                                  comment.comment,
                                                  style: const TextStyle(fontSize: 15),
                                                ),
                                              ],
                                            ),
                                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
