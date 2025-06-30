import 'package:flutter/material.dart';

class UserInfo {
  final String username;
  final String password;

  UserInfo({required this.password, required this.username});

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(password: json['password'], username: json['username']);
  }

  Map<String, dynamic> toJson() {
    return {"username": this.username, "password": this.password};
  }
}
