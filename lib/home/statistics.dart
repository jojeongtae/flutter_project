import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jomakase/public_file/layout.dart';
import 'package:jomakase/public_file/world_cup_item.dart';

class Statistics extends StatelessWidget {
  final String? category;

  Statistics({super.key, required this.category});

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

  Future<List<CommentItem>> fetchComments(int winnerid) async {
    final url = Uri.parse(
      "http://10.0.2.2:8080/result/comment?winnerid=$winnerid&winnertype=${category}_world_cup",
    );
    final res = await http.get(url);
    if (res.body.trim().isEmpty) {
      return [];
    }
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
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Material(
                  elevation: 2,
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  child: InkWell(
                    onTap: () {
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
                                                          comment.nickname,
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
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // 트로피 아이콘 (1~3등만)
                          if (index < 3)
                            Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: Icon(
                                Icons.emoji_events,
                                color: index == 0
                                    ? Colors.amber
                                    : index == 1
                                    ? Colors.grey
                                    : Colors.brown,
                                size: 28,
                              ),
                            )
                          else
                            const SizedBox(width: 34), // 아이콘 없는 등수는 여백만

                          // 순위 원형
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.blueAccent,
                            child: Text(
                              "${index + 1}",
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),

                          const SizedBox(width: 12),

                          // ✅ Expanded로 감싸서 남은 공간 확보
                          Expanded(
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    item.imageurl,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // 이름, 우승횟수, 게이지바 등 텍스트 정보들
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.name,
                                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        "우승 횟수: ${item.count}",
                                        style: const TextStyle(color: Colors.grey, fontSize: 14),
                                      ),
                                      const SizedBox(height: 6),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: LinearProgressIndicator(
                                          value: item.rating,
                                          minHeight: 8,
                                          backgroundColor: Colors.grey.shade200,
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                            item.rating > 0.7
                                                ? Colors.green
                                                : item.rating > 0.4
                                                ? Colors.orange
                                                : Colors.red,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 8),

                          Column(
                            children: [
                              const Icon(Icons.bar_chart, size: 20, color: Colors.grey),
                              Text(
                                "${(item.rating * 100).round()}%",
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
