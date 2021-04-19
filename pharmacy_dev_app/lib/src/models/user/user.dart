class User {
  int id;
  String name;
  String email;
  String phone;
  String loginToken;
  String dynamicReferralLink;
  String rank;

  User(
      {this.id,
      this.name,
      this.email,
      this.phone,
      this.loginToken,
      this.dynamicReferralLink,
      this.rank});

  User.none()
      : id = null,
        name = "",
        email = "",
        phone = "",
        loginToken = "",
        dynamicReferralLink = "",
        rank = 'normal';

  factory User.fromJson(Map<String, dynamic> jsonData) {
    return User(
      id: jsonData['id'],
      name: jsonData['name'],
      email: jsonData['email'],
      phone: jsonData['verified_phone'],
      loginToken: jsonData['login_token'],
      dynamicReferralLink: jsonData['dynamic_referral_link'],
      rank: jsonData['rank'],
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
    data['rank'] = rank;
    return data;
  }
}
