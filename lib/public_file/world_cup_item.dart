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
  final WorldcupItem food1;
  final WorldcupItem food2;

  FoodPair({required this.food1, required this.food2});

  factory FoodPair.fromJson(Map<String, dynamic> json) {
    return FoodPair(
      food1: WorldcupItem.fromJson(json['food1']),
      food2: WorldcupItem.fromJson(json['food2']),
    );
  }
}