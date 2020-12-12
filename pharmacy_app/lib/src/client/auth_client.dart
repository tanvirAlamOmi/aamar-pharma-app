import 'dart:convert';
import 'dart:io';
import 'package:pharmacy_app/src/configs/server_config.dart';
import 'package:pharmacy_app/src/store/store.dart';
import 'package:http/http.dart' as http;


class AuthClient {
  AuthClient() {
    print("AuthClient Initialized");
  }

  Future<dynamic> logIn(String signInRequest) async {
    final http.Response response = await http
        .post(
          ServerConfig.SERVER_HOST +
              ServerConfig.SERVER_PORT.toString() +
              '/api/adminapi/login',
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: signInRequest,
        )
        .timeout(Duration(seconds: 20));

    final jsonResponse = json.decode(response.body);
    return jsonResponse;
  }


  static AuthClient _instance;
  static AuthClient get instance => _instance ??= AuthClient();
}
