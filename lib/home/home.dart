import 'package:flutter/material.dart';
import 'package:jomakase/public_file/layout.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<String> categories = ['과자', '과일', '반찬', '음식',"음료"];
  final Set<String> selectedCategories = {};

  @override
  Widget build(BuildContext context) {
    return Layout2(
      title: "갈드컵 모음집",
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: categories
                .map(
                  (category) => Row(
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
                      Text(category,style: TextStyle(fontWeight: FontWeight.bold),),
                    ],
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
