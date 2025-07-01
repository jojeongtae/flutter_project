import 'package:flutter/material.dart';
import 'package:jomakase/home/worldcup_page.dart';
import 'package:jomakase/public_file/layout.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<String> categories = ['과자', '과일', '반찬', '음식', '음료'];
  final Set<String> selectedCategories = {};

  final List<String> worldcupList = [
    "음식 월드컵 32강",
    "과일 월드컵 32강",
    "반찬 월드컵 32강",
    "음료 월드컵 32강",
    "과자 월드컵 32강",
  ];
  String convertTitleToCategory(String title) {
    if (title.contains("과자")) return "snack";
    if (title.contains("과일")) return "fruit";
    if (title.contains("반찬")) return "side";
    if (title.contains("음료")) return "drink";
    if (title.contains("음식")) return "food";
    return "unknown";
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = selectedCategories.isEmpty
        ? worldcupList
        : worldcupList.where((item) {
      return selectedCategories.any((category) => item.contains(category));
    }).toList();

    return Layout2(
      title: "이상형 월드컵 모음집",
      child: Column(
        children: [
          // ✅ 카테고리 필터
          Wrap(
            spacing: 10,
            children: categories.map((category) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(
                    value: selectedCategories.contains(category),
                    onChanged: (bool? checked) {
                      setState(() {
                        if (checked == true) {
                          selectedCategories.add(category);
                        } else {
                          selectedCategories.remove(category);
                        }
                      });
                    },
                  ),
                  Text(category, style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              );
            }).toList(),
          ),
          const Divider(),

          // ✅ 필터링된 월드컵 리스트
          Expanded(
            child: ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                final item = filteredList[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WorldcupPage(title: item,category: convertTitleToCategory(item)),
                      ),
                    );
                  },
                  child: Container(
                    height: 80, // 항목 높이 크게
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.emoji_events, size: 28),
                            SizedBox(width: 12),
                            Text(item, style: TextStyle(fontSize: 20)),
                          ],
                        ),
                        Icon(Icons.arrow_forward_ios),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
