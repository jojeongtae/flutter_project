import 'package:flutter/material.dart';
import 'package:jomakase/public_file/layout.dart';
import 'package:jomakase/public_file/world_cup_item.dart';
import 'package:jomakase/public_file/api_service.dart'; // ApiService import

class Statistics extends StatelessWidget {
  final String? category;

  Statistics({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Colors.deepPurple;
    final Color accentColor = Colors.amber;
    final Color backgroundColor = Colors.grey.shade50;
    final Color textColor = Colors.grey.shade800;
    final Color subtleTextColor = Colors.grey.shade600;

    return Layout2(
      title: "최종 순위표",
      child: Container(
        color: backgroundColor,
        child: FutureBuilder<List<RankingItem>>(
          future: ApiService.fetchRanking(category!), // ApiService.fetchRanking 호출
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(primaryColor)));
            } else if (snapshot.hasError) {
              return Center(child: Text("에러 발생: ${snapshot.error}", style: TextStyle(color: Colors.red.shade700)));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("순위 데이터가 없습니다."));
            }

            final rankings = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              itemCount: rankings.length,
              itemBuilder: (context, index) {
                final item = rankings[index];
                return Card(
                  elevation: 3.0,
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                  child: InkWell(
                    onTap: () => _showCommentsDialog(context, item, primaryColor, textColor),
                    borderRadius: BorderRadius.circular(15.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          _buildRankIndicator(index, primaryColor),
                          const SizedBox(width: 16),
                          _buildItemImage(item.imageurl),
                          const SizedBox(width: 16),
                          _buildItemInfo(item, textColor, subtleTextColor),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildRankIndicator(int index, Color primaryColor) {
    if (index < 3) {
      return Column(
        children: [
          Icon(
            Icons.emoji_events,
            color: index == 0 ? Colors.amber.shade600 : (index == 1 ? Colors.grey.shade500 : Colors.brown.shade400),
            size: 32,
          ),
          const SizedBox(height: 4),
          Text(
            "${index + 1}위",
            style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor, fontSize: 16),
          ),
        ],
      );
    }
    return CircleAvatar(
      backgroundColor: primaryColor.withOpacity(0.8),
      child: Text(
        "${index + 1}",
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildItemImage(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: Image.network(
        imageUrl,
        width: 70,
        height: 70,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const Icon(Icons.fastfood, size: 70),
      ),
    );
  }

  Widget _buildItemInfo(RankingItem item, Color textColor, Color subtleTextColor) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.name,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            "우승 횟수: ${item.count}",
            style: TextStyle(color: subtleTextColor, fontSize: 14),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: item.rating,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(
              item.rating > 0.7 ? Colors.green.shade500 : (item.rating > 0.4 ? Colors.orange.shade500 : Colors.red.shade500),
            ),
          ),
        ],
      ),
    );
  }

  void _showCommentsDialog(BuildContext context, RankingItem item, Color primaryColor, Color textColor) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "'${item.name}'에 대한 댓글",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: primaryColor),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 300,
                  child: FutureBuilder<List<CommentItem>>(
                    future: ApiService.fetchComments(item.id, "${category}_world_cup"), // ApiService.fetchComments 호출
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(primaryColor)));
                      } else if (snapshot.hasError) {
                        return Text("에러: ${snapshot.error}", style: TextStyle(color: Colors.red.shade700));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text("아직 댓글이 없습니다."));
                      }

                      final comments = snapshot.data!;
                      return ListView.separated(
                        itemCount: comments.length,
                        separatorBuilder: (context, index) => const Divider(),
                        itemBuilder: (context, index) {
                          final comment = comments[index];
                          return ListTile(
                            leading: const Icon(Icons.account_circle, size: 40),
                            title: Text(comment.nickname, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(comment.comment),
                            trailing: Text(
                              comment.playedAt.toString().substring(0, 10),
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text("닫기", style: TextStyle(color: primaryColor)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}