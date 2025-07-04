import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jomakase/public_file/world_cup_item.dart'; // models
import 'package:jomakase/public_file/token.dart';
import 'package:jomakase/public_file/userinfo.dart';

class ApiService {
  static const String baseUrl = "http://10.0.2.2:8080";

  static Future<void> logout() async {
    final url = Uri.parse("$baseUrl/logout1");
    await http.post(url);
  }

  static Future<Map<String, dynamic>> login(String username, String password) async {
    final url = Uri.parse("$baseUrl/login");
    final Map<String, String> data = {
      'username': username,
      'password': password,
    };
    final res = await http.post(url, headers: {'Content-Type': 'application/x-www-form-urlencoded'}, body: data);
    if (res.statusCode == 200) {
      return {
        'token': res.headers['authorization']?.replaceFirst('Bearer ', ''),
        'refresh': res.headers['set-cookie'],
        'userInfo': json.decode(utf8.decode(res.bodyBytes)),
      };
    } else {
      throw Exception(json.decode(utf8.decode(res.bodyBytes))['error']);
    }
  }

  static Future<void> signup(Map<String, dynamic> userData) async {
    final url = Uri.parse("$baseUrl/join");
    final res = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(userData),
    );
    if (res.statusCode != 200) {
      throw Exception(json.decode(utf8.decode(res.bodyBytes))['error']);
    }
  }

  static Future<void> updateProfile(String token, Map<String, dynamic> userData) async {
    final url = Uri.parse("$baseUrl/user/modify");
    final res = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: json.encode(userData),
    );
    if (res.statusCode != 200) {
      throw Exception("Failed to update profile");
    }
  }

  static Future<List<RankingItem>> fetchRanking(String category) async {
    final url = Uri.parse("$baseUrl/result/${category}_world_cup");
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final List<dynamic> result = json.decode(utf8.decode(res.bodyBytes));
      return result.map((e) => RankingItem.fromJson(e)).toList();
    } else {
      throw Exception("순위 데이터를 불러오지 못했습니다");
    }
  }

  static Future<List<CommentItem>> fetchComments(int winnerid, String winnertype) async {
    final url = Uri.parse("$baseUrl/result/comment?winnerid=$winnerid&winnertype=$winnertype");
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

  static Future<List<WorldcupItem>> fetchWorldcupItems(String category) async {
    final url = Uri.parse("$baseUrl/$category");
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(utf8.decode(res.bodyBytes));
      final pairs = jsonList.map((e) => FoodPair.fromJson(e)).toList();
      return pairs.expand((p) => [p.item1, p.item2]).toList()..shuffle();
    } else {
      throw Exception("Failed to load data from server");
    }
  }

  static Future<CommentItem> saveWorldcupResult(String username, String winnertype, int winnerid, String comment) async {
    final url = Uri.parse("$baseUrl/result/save");
    final body = json.encode({
      "username": username,
      "winnertype": winnertype,
      "winnerid": winnerid,
      "comment": comment,
    });

    final res = await http.post(url, headers: {"Content-Type": "application/json"}, body: body);
    if (res.statusCode == 200) {
      return CommentItem.fromJson(json.decode(utf8.decode(res.bodyBytes)));
    } else {
      throw Exception("Failed to save result");
    }
  }

  static Future<void> updateComment(int commentId, String comment) async {
    final url = Uri.parse("$baseUrl/result/comment?id=$commentId&comment=$comment");
    final res = await http.put(url);
    if (res.statusCode != 200) {
      throw Exception("Failed to update comment");
    }
  }
}