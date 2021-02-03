import 'dart:convert';

import 'package:pharmacy_app/src/store/store.dart';

class User {
  int id;
  String name;
  String email;
  String phone;
  String userType;
  String token;

  User({this.id, this.name, this.email, this.phone, this.userType, this.token});

  User.blank()
      : id = 0,
        name = "",
        email = "",
        phone = "",
        token = "";

  User.none()
      : id = null,
        name = "",
        email = "",
        phone = "",
        token = "";

  User.basic()
      : id = 1,
        name = Store.instance.appState.user.name,
        email = Store.instance.appState.user.email,
        phone = Store.instance.appState.user.phone,
        token = "custom-token-api";

  factory User.fromJson(Map<String, dynamic> jsonData) {
    return User(
      id: jsonData['id'],
      name: jsonData['name'],
      email: jsonData['email'],
      phone: jsonData['phone'],
      userType: jsonData['user_type'],
      token: jsonData['token'],
    );
  }

  String toJsonString() {
    final data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['user_type'] = userType;
    data['token'] = token;
    return json.encode(data);
  }

  Map<String, dynamic> toJsonMap() {
    final data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['user_type'] = userType;
    data['token'] = token;
    return data;
  }
}
