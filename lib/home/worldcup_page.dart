import 'package:flutter/material.dart';
import 'package:jomakase/home/statistics.dart';
import 'package:jomakase/public_file/layout.dart';
import 'package:jomakase/public_file/userinfo.dart';
import 'package:jomakase/public_file/world_cup_item.dart';
import 'package:confetti/confetti.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:jomakase/public_file/api_service.dart'; // ApiService import

class WorldcupPage extends StatefulWidget {
  final String? title;
  final String? category;
  final int? count; // count 필드 추가

  const WorldcupPage({super.key, required this.title, this.category, this.count});

  @override
  State<WorldcupPage> createState() => _WorldcupPageState();
}

class _WorldcupPageState extends State<WorldcupPage> with TickerProviderStateMixin {
  late Future<List<WorldcupItem>> futureItems;
  final List<WorldcupItem> currentRound = [];
  final List<WorldcupItem> nextRound = [];
  int currentIndex = 0;
  WorldcupItem? winner;
  CommentItem? com;
  late ConfettiController _confettiController;
  bool resultSaved = false;
  final TextEditingController _commentController = TextEditingController();
  
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    futureItems = ApiService.fetchWorldcupItems(widget.category!).then((items) {
      if (widget.count != null && items.length > widget.count!) {
        return items.sublist(0, widget.count!); // count에 따라 아이템 제한
      }
      return items;
    });
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _commentController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> updateComment(String comment) async {
    try {
      await ApiService.updateComment(com!.id, comment); // ApiService.updateComment 호출
    } catch (e) {
      debugPrint("Comment update error: \$e");
    }
  }

  Future<void> resultSave(String comment) async {
    try {
      final user = context.read<UserInfo>();
      final winnertype = "${widget.category}_world_cup"; // 복구
      await ApiService.saveWorldcupResult(user.username!, winnertype, winner!.id, comment); // ApiService.saveWorldcupResult 호출
      resultSaved = true;
    } catch (e) {
      debugPrint("Result save error: \$e");
    }
  }

  void selectWinner(WorldcupItem selected) {
    _animationController.forward(from: 0.0);
    nextRound.add(selected);
    if (currentIndex + 2 < currentRound.length) {
      setState(() => currentIndex += 2);
    } else {
      if (nextRound.length == 1) {
        setState(() {
          winner = nextRound.first;
          _confettiController.play();
        });
        if (!resultSaved) {
          resultSave(_commentController.text);
          resultSaved = true;
        }
      } else {
        setState(() {
          currentRound..clear()..addAll(nextRound);
          nextRound.clear();
          currentIndex = 0;
        });
      }
    }
  }

  Widget buildChoiceCard(WorldcupItem item) {
    return Card(
      elevation: 2.0, // Reduced elevation
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        // side: BorderSide(color: Colors.grey.shade200), // Removed the subtle border
      ),
      clipBehavior: Clip.antiAlias, // Ensure content is clipped to border radius
      child: InkWell(
        onTap: () => selectWinner(item),
        borderRadius: BorderRadius.circular(16.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
              child: Image.network(
                item.imageurl,
                width: 400,
                height: 280, // Adjusted height to be slightly smaller than 180
                fit: BoxFit.contain,
                errorBuilder: (c, e, s) => Icon(Icons.error, size: 120, color: Theme.of(context).colorScheme.error),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0), // Reverted vertical padding
              child: Text(
                item.name,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMatchView(WorldcupItem left, WorldcupItem right) {
    return FadeTransition(
      opacity: _animation,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Changed to spaceEvenly
        children: [
          Expanded(child: buildChoiceCard(left)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0), // Reverted vertical padding
            child: Text(
              "VS",
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          Expanded(child: buildChoiceCard(right)),
        ],
      ),
    );
  }

  Widget buildWinnerView() {
    final Color primaryColor = Colors.deepPurple;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [Colors.red, Colors.blue, Colors.orange, Colors.green, Colors.purple],
              emissionFrequency: 0.05,
              numberOfParticles: 20,
            ),
            Text("🏆 최종 우승 🏆", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.secondary)),
            const SizedBox(height: 24),
            ScaleTransition(
              scale: Tween<double>(begin: 0.5, end: 1.0).animate(CurvedAnimation(parent: _animationController, curve: Curves.elasticOut)),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(150)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(150),
                  child: Image.network(winner!.imageurl, width: 200, height: 200, fit: BoxFit.cover),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(winner!.name, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyLarge?.color)),
            const SizedBox(height: 32),
            TextField(
              controller: _commentController,
              decoration: InputDecoration(
                labelText: "우승자에게 한마디!",
                hintText: "예: 정말 맛있어 보여요!",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.comment),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                updateComment(_commentController.text.trim());
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("댓글이 저장되었습니다.")));
              },
              icon: const Icon(Icons.save),
              label: const Text("댓글 저장"),
              style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Theme.of(context).colorScheme.onPrimary, padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Statistics(category: widget.category))), child: Text("전체 순위 보기")),
                ElevatedButton(onPressed: () => Navigator.pop(context), child: Text("홈으로 돌아가기")),
                ElevatedButton.icon(
                  onPressed: () async {
                    final url = Uri.parse("https://www.google.com/search?q=${Uri.encodeComponent(winner!.name)}");
                    if (await canLaunchUrl(url)) await launchUrl(url);
                  },
                  icon: const Icon(Icons.search),
                  label: Text("웹에서 검색"),
                ),
              ],
            ),
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
            return Center(child: Text("에러: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("월드컵 아이템이 없습니다."));
          }

          if (currentRound.isEmpty && winner == null) {
            currentRound.addAll(snapshot.data!); 
            _animationController.forward();
          }

          if (winner != null) return buildWinnerView();

          if (currentIndex + 1 >= currentRound.length) {
            return const Center(child: Text("라운드 진행에 필요한 데이터가 부족합니다."));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  "${currentRound.length}강",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyLarge?.color),
                ),
                const SizedBox(height: 8),
                Text(
                  "마음에 드는 것을 선택하세요!",
                  style: TextStyle(fontSize: 16, color: Theme.of(context).textTheme.bodyMedium?.color),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: buildMatchView(
                    currentRound[currentIndex],
                    currentRound[currentIndex + 1],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
