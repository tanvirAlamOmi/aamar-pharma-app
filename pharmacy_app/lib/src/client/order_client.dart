import 'dart:convert';
import 'package:pharmacy_app/src/configs/server_config.dart';
import 'package:http/http.dart' as http;

class OrderClient {
  OrderClient() {
    print("OrderClient Initialized");
  }

  Future<dynamic> getOrderItems(String jwtToken, int orderItemsById) async {
    final http.Response response = await http.get(
      ServerConfig.SERVER_HOST +
          ServerConfig.SERVER_PORT.toString() +
          '/api/adminapi/orderedItemsById/${orderItemsById}',
      headers: {
        'token': jwtToken,
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).timeout(Duration(seconds: 300));

    final jsonResponse = json.decode(response.body);
    return jsonResponse;
  }

  Future<dynamic> orderWithPrescription(
      String jwtToken, String orderRequest) async {
    final http.Response response = await http
        .post(
            ServerConfig.SERVER_HOST +
                ServerConfig.SERVER_PORT.toString() +
                '/api/appapi/order-prescription',
            headers: {
              'token': jwtToken,
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: orderRequest)
        .timeout(Duration(seconds: 300));

    final jsonResponse = json.decode(response.body);
    return jsonResponse;
  }

  Future<dynamic> orderWithItems(String jwtToken, String orderRequest) async {
    final http.Response response = await http
        .post(
            ServerConfig.SERVER_HOST +
                ServerConfig.SERVER_PORT.toString() +
                '/api/appapi/order-with-items',
            headers: {
              'token': jwtToken,
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: orderRequest)
        .timeout(Duration(seconds: 300));

    final jsonResponse = json.decode(response.body);
    return jsonResponse;
  }

  static OrderClient _instance;
  static OrderClient get instance => _instance ??= OrderClient();
}
