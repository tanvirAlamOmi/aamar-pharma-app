class User {
  String id;
  String name;
  String userType;
  String token;

  User({this.id, this.name, this.userType, this.token});

  User.blank()
      : id = "NONE",
        name = "USER",
        userType = "super_admin",
        token = "NONE";

  factory User.fromJson(Map<String, dynamic> jsonData) {
    return User(
      id: jsonData['id'],
      name: jsonData['name'],
      userType: jsonData['user_type'],
      token: jsonData['token'],
    );
  }

  Map<String, dynamic> toJsonMap() {
    final data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['user_type'] = userType;
    data['token'] = token;
    return data;
  }
}
