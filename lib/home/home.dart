import 'package:flutter/material.dart';
import 'package:jomakase/home/worldcup_page.dart';
import 'package:jomakase/public_file/layout.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<String> categories = ['과자', '과일', '반찬', '음식', '음료', "알콜","괴식"];
  final Set<String> selectedCategories = {};

  final List<String> worldcupList = [
    "음식 월드컵 32강",
    "과일 월드컵 32강",
    "반찬 월드컵 32강",
    "음료 월드컵 32강",
    "과자 월드컵 32강",
    "알콜 월드컵 32강",
    "괴식 월드컵 32강"
  ];

  String convertTitleToCategory(String title) {
    if (title.contains("과자")) return "snack";
    if (title.contains("과일")) return "fruit";
    if (title.contains("반찬")) return "banchan";
    if (title.contains("음료")) return "beverage";
    if (title.contains("음식")) return "food";
    if (title.contains("알콜")) return "alcohol";
    if (title.contains("괴식")) return "gwaesik";
    return "unknown";
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = selectedCategories.isEmpty
        ? worldcupList
        : worldcupList
        .where((item) => selectedCategories.any((category) => item.contains(category)))
        .toList();
    
    // Define a modern color scheme
    final Color primaryColor = Theme.of(context).primaryColor;
    final Color accentColor = Theme.of(context).colorScheme.secondary;
    final Color backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final Color textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    final Color subtleTextColor = Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey;

    return Layout2(
      title: "이상형 월드컵 모음집",
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Filter Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "카테고리 선택",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: categories.map((category) {
                  final isSelected = selectedCategories.contains(category);
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: FilterChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            selectedCategories.add(category);
                          } else {
                            selectedCategories.remove(category);
                          }
                        });
                      },
                      backgroundColor: isSelected ? primaryColor : Theme.of(context).colorScheme.surface,
                      selectedColor: primaryColor.withOpacity(0.2),
                      labelStyle: TextStyle(
                        color: isSelected ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).textTheme.bodyLarge?.color,
                        fontWeight: FontWeight.w600,
                      ),
                      checkmarkColor: Theme.of(context).colorScheme.onPrimary,
                      shape: StadiumBorder(
                        side: BorderSide(
                          color: isSelected ? primaryColor : Theme.of(context).dividerColor,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 10),
            const Divider(indent: 16, endIndent: 16),

            // World Cup List Section
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  final item = filteredList[index];
                  return Card(
                    elevation: 2.0,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      leading: CircleAvatar(
                        backgroundColor: accentColor,
                        child: const Icon(Icons.emoji_events, color: Colors.white),
                      ),
                      title: Text(
                        item,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                          fontSize: 17,
                        ),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: subtleTextColor),
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext bc) {
                            return SafeArea(
                              child: Wrap(
                                children: <Widget>[
                                  ListTile(
                                    leading: const Icon(Icons.looks_3),
                                    title: const Text('32강'),
                                    onTap: () {
                                      Navigator.pop(bc);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => WorldcupPage(
                                            title: item,
                                            category: convertTitleToCategory(item),
                                            count: 32,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.looks_two),
                                    title: const Text('16강'),
                                    onTap: () {
                                      Navigator.pop(bc);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => WorldcupPage(
                                            title: item,
                                            category: convertTitleToCategory(item),
                                            count: 16,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.looks_one),
                                    title: const Text('8강'),
                                    onTap: () {
                                      Navigator.pop(bc);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => WorldcupPage(
                                            title: item,
                                            category: convertTitleToCategory(item),
                                            count: 8,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
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