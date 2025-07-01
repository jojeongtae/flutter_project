import 'package:flutter/material.dart';

class WorldcupItem {
  final String name;
  final String imageurl;

  WorldcupItem({required this.name, required this.imageurl});

  factory WorldcupItem.fromJson(Map<String, dynamic> json) {
    return WorldcupItem(
      name: json['name'],
      imageurl: json['imageurl'],
    );
  }
}

class FoodPair {
  final WorldcupItem item1;
  final WorldcupItem item2;

  FoodPair({required this.item1, required this.item2});

  factory FoodPair.fromJson(Map<String, dynamic> json) {
    return FoodPair(
      item1: WorldcupItem.fromJson(json['item1']),
      item2: WorldcupItem.fromJson(json['item2']),
    );
  }
}