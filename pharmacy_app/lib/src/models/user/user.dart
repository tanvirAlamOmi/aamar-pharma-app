class User {
  String id;
  String name;
  String email;
  String phone;
  String token;

  User({this.id, this.name, this.email, this.phone, this.token});

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
      token: jsonData['token'],
    );
  }

  Map<String, dynamic> toJsonMap() {
    final data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['token'] = token;
    return data;
  }
}
