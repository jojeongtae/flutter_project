import 'package:flutter/material.dart';

class UserInfo extends ChangeNotifier{
   String? username;
   String? password;
   String? email;
   String? phone;
   String? nickname;
   String? token; // token 필드 추가

  UserInfo({
     this.username,
     this.password,
     this.email,
     this.phone,
     this.nickname,
     this.token,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      username: json['username'],
      password: json['password'],
      email: json['email'],
      phone: json['phone'],
      nickname: json['nickname'],
    );

  }

  Map<String, dynamic> toJson() => {
    'username': username,
    'password': password,
    'email': email,
    'phone': phone,
    'nickname': nickname,
  };
  void updateFromJson(Map<String, dynamic> json) {
    username = json['username'];
    password = json['password'];
    email = json['email'];
    phone = json['phone'];
    nickname = json['nickname'];
    notifyListeners();
  }

  void updateFromOtherUserInfo(UserInfo other) {
    username = other.username;
    password = other.password;
    email = other.email;
    phone = other.phone;
    nickname = other.nickname;
    token = other.token;
    notifyListeners();
  }

void clear(){
  username = "";
  password = "";
  email = "";
  phone = "";
  nickname = "";
  notifyListeners();
}
}
