import 'dart:convert';
import 'package:pharmacy_app/src/configs/server_config.dart';
import 'package:http/http.dart' as http;

class DeliveryClient {
  DeliveryClient() {
    print("OrderClient Initialized");
  }

  Future<dynamic> addDeliveryAddress(
      String jwtToken, String addDeliveryAddressRequest) async {
    final http.Response response = await http
        .post(
            ServerConfig.SERVER_HOST +
                ServerConfig.SERVER_PORT +
                '/api/appapi/addDeliveryAddress',
            headers: {
              'token': jwtToken,
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: addDeliveryAddressRequest)
        .timeout(Duration(seconds: 300));

    final jsonResponse = json.decode(response.body);
    return jsonResponse;
  }

  Future<dynamic> deliveryAddressListCustomer(String jwtToken, String customerId) async {
    final http.Response response = await http.get(
      ServerConfig.SERVER_HOST +
          ServerConfig.SERVER_PORT +
          '/api/appapi/addresslist/${customerId}',
      headers: {
        'token': jwtToken,
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).timeout(Duration(seconds: 300));

    final jsonResponse = json.decode(response.body);
    return jsonResponse;
  }

  static DeliveryClient _instance;
  static DeliveryClient get instance => _instance ??= DeliveryClient();
}
