import 'dart:convert';
import 'package:pharmacy_app/src/configs/server_config.dart';
import 'package:http/http.dart' as http;
import 'package:pharmacy_app/src/models/general/Enum_Data.dart';
import 'dart:math';

class NotificationClient {
  NotificationClient() {
    print("NotificationClient Initialized");
  }

  Future<dynamic> notificationCount(String jwtToken, int userId) async {
    var random = new Random();
    return json.decode(jsonEncode(<String, dynamic>{
      'NOTIFICATION': random.nextInt(100),
      'STATUS': true,
      'result': ClientEnum.RESPONSE_SUCCESS
    }));
    final http.Response response = await http.get(
      ServerConfig.SERVER_HOST +
          ServerConfig.SERVER_PORT +
          '/api/appapi/notification-count',
      headers: {
        'token': jwtToken,
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).timeout(Duration(seconds: 300));

    final jsonResponse = json.decode(response.body);
    return jsonResponse;
  }

  static NotificationClient _instance;
  static NotificationClient get instance => _instance ??= NotificationClient();
}
