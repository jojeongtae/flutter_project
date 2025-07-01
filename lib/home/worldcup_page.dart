import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jomakase/public_file/layout.dart';
import 'package:jomakase/public_file/world_cup_item.dart';
import 'package:confetti/confetti.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class WorldcupPage extends StatefulWidget {
  final String? title;
  final String? category;

  const WorldcupPage({super.key, required this.title, required this.category});

  @override
  State<WorldcupPage> createState() => _WorldcupPageState();
}

class _WorldcupPageState extends State<WorldcupPage> {
  late Future<List<WorldcupItem>> futureItems;
  List<WorldcupItem> currentRound = [];
  List<WorldcupItem> nextRound = [];
  int currentIndex = 0;
  WorldcupItem? winner;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    futureItems = fetchData();
    _confettiController = ConfettiController(duration: Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  Future<List<WorldcupItem>> fetchData() async {
    final url = Uri.parse("http://10.0.2.2:8080/${widget.category}");
    final res = await http.get(url);
    print(res.statusCode);
    if (res.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(utf8.decode(res.bodyBytes));
      final pairs = jsonList.map((e) => FoodPair.fromJson(e)).toList();

      List<WorldcupItem> items = [];
      for (var pair in pairs) {
        items.add(pair.item1);
        items.add(pair.item2);
      }
      return items;
    } else {
      throw Exception("서버에서 데이터를 불러오지 못했습니다");
    }
  }

  void selectWinner(WorldcupItem selected) {
    nextRound.add(selected);
    if (currentIndex + 2 < currentRound.length) {
      setState(() {
        currentIndex += 2;
      });
    } else {
      if (nextRound.length == 1) {
        setState(() {
          winner = nextRound.first;
          _confettiController.play(); // 🎉 파티클 실행
        });
      } else {
        setState(() {
          currentRound = nextRound;
          nextRound = [];
          currentIndex = 0;
        });
      }
    }
  }

  Widget buildMatchView(WorldcupItem left, WorldcupItem right) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [buildChoiceCard(left), buildChoiceCard(right)],
    );
  }

  Widget buildChoiceCard(WorldcupItem item) {
    return Expanded(
      child: GestureDetector(
        onTap: () => selectWinner(item),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                item.imageurl,
                width: 160,
                height: 160,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 10),
            Text(item.name, style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Layout2(
      title: widget.title ?? "이상형 월드컵",
      child: FutureBuilder<List<WorldcupItem>>(
        future: futureItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("에러 발생: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("데이터가 없습니다."));
          }

          if (currentRound.isEmpty && winner == null) {
            currentRound = snapshot.data!;
          }

          if (winner != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: ConfettiWidget(
                      confettiController: _confettiController,
                      blastDirectionality: BlastDirectionality.explosive,
                      shouldLoop: false,
                      colors: const [
                        Colors.red,
                        Colors.blue,
                        Colors.orange,
                        Colors.green,
                        Colors.purple,
                      ],
                      emissionFrequency: 0.05,
                      numberOfParticles: 10,
                    ),
                  ),
                  Text("🎉 우승자 🎉", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  Center(
                    child: TweenAnimationBuilder(
                      tween: Tween(begin: 0.5, end: 1.0),
                      duration: Duration(milliseconds: 800),
                      curve: Curves.elasticOut,
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: Image.network(winner!.imageurl, width: 160, height: 160,cacheWidth: 160,),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.8, end: 1.0),
                    duration: Duration(milliseconds: 500),
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Text(
                          winner!.name,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("월드컵 리스트로 돌아가기"),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      ElevatedButton.icon(
                        onPressed: () async {
                          final query = Uri.encodeComponent(winner!.name); // 예: "피자" → "%ED%94%BC%EC%9E%90"
                          final url = Uri.parse("https://google.com/search?q=$query 추천");
                          await launchUrl(url, mode: LaunchMode.externalApplication);
                          // final url = "https://google.com/$winnerName";);

                        },
                        icon: Icon(Icons.link),
                        label: Text("링크 열기"),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }

          if (currentIndex + 1 >= currentRound.length) {
            return const Center(child: Text("데이터 부족"));
          }

          final left = currentRound[currentIndex];
          final right = currentRound[currentIndex + 1];

          return Column(
            children: [
              SizedBox(height: 20),
              Text(
                "현재 라운드: ${currentRound.length}강",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              buildMatchView(left, right),

            ],
          );
        },
      ),
    );
  }
}
