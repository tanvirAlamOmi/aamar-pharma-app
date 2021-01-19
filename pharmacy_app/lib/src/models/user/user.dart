class User {
  String id;
  String name;
  String email;
  String phone;
  String userType;
  String token;

  User({this.id, this.name, this.email, this.phone, this.userType, this.token});

  User.blank()
      : id = "0",
        name = "GUEST",
        email = "N/A",
        phone = "N/A",
        token = "NONE";

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
