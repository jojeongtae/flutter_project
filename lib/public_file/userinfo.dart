import 'package:flutter/material.dart';

class UserInfo extends ChangeNotifier{
   String? username;
   String? password;
   String? email;
   String? phone;
   String? nickname;

  UserInfo({
     this.username,
     this.password,
     this.email,
     this.phone,
     this.nickname,
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

void clear(){
  username = "";
  password = "";
  email = "";
  phone = "";
  nickname = "";
  notifyListeners();
}
}
