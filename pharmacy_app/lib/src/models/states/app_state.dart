import 'package:pharmacy_app/src/models/user/user.dart';

class AppState {
  User user = new User();
  String firebasePushNotificationToken = "";

  AppState() {}

  AppState.fromJsonMap(Map<String, dynamic> data) {
    user = User.fromJson(data['USER']);
    firebasePushNotificationToken = data['FIREBASE_PUSH_NOTIFICATION_TOKEN'];

  }

  Map<String, dynamic> toJsonMap() {
    final data = Map<String, dynamic>();
    data['USER'] = user.toJsonMap();
    data['FIREBASE_PUSH_NOTIFICATION_TOKEN'] = firebasePushNotificationToken;

    return data;
  }
}
