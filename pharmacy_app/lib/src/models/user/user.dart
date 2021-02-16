import 'dart:convert';

import 'package:pharmacy_app/src/models/states/app_vary_states.dart';
import 'package:pharmacy_app/src/store/store.dart';

class User {
  int id;
  String name;
  String email;
  String phone;
  String loginToken;
  String dynamicReferralLink;

  User(
      {this.id,
      this.name,
      this.email,
      this.phone,
      this.loginToken,
      this.dynamicReferralLink});


  User.none()
      : id = null,
        name = "",
        email = "",
        phone = "",
        loginToken = "",
        dynamicReferralLink = "";


  factory User.fromJson(Map<String, dynamic> jsonData) {
    return User(
      id: jsonData['id'],
      name: jsonData['name'],
      email: jsonData['email'],
      phone: jsonData['verified_phone'],
      loginToken: jsonData['login_token'],
      dynamicReferralLink: jsonData['dynamic_referral_link'],
    );
  }

  Map<String, dynamic> toJsonMap() {
    final data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['verified_phone'] = phone;
    data['login_token'] = loginToken;
    data['dynamic_referral_link'] = dynamicReferralLink;
    return data;
  }
}
