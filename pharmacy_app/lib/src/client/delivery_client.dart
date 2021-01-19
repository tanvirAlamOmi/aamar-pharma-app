import 'dart:convert';
import 'package:pharmacy_app/src/configs/server_config.dart';
import 'package:http/http.dart' as http;

class DeliveryClient {
  DeliveryClient() {
    print("OrderClient Initialized");
  }

  Future<dynamic> addDeliveryAddress(String jwtToken, int orderItemsById) async {
    final http.Response response = await http.post(
      ServerConfig.SERVER_HOST +
          ServerConfig.SERVER_PORT +
          '/arbreepharmacy/api/appapi/addDeliveryAddress',
      headers: {
        'token': jwtToken,
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: orderItemsById
    ).timeout(Duration(seconds: 300));

    final jsonResponse = json.decode(response.body);
    return jsonResponse;
  }



  static DeliveryClient _instance;
  static DeliveryClient get instance => _instance ??= DeliveryClient();
}
