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

  Future<dynamic> changeOrderStatus(
      String jwtToken, String orderId, String orderStatus) async {
    final http.Response response = await http.get(
      ServerConfig.SERVER_HOST +
          ServerConfig.SERVER_PORT.toString() +
          '/api/adminapi/changeOrderStatus/${orderId}/${orderStatus}',
      headers: {
        'token': jwtToken,
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).timeout(Duration(seconds: 300));

    final jsonResponse = json.decode(response.body);
    return jsonResponse;
  }

  Future<dynamic> changeOrderPaymentStatus(
      String jwtToken, String orderId, String orderPaymentStatus) async {
    final http.Response response = await http.get(
      ServerConfig.SERVER_HOST +
          ServerConfig.SERVER_PORT.toString() +
          '/api/adminapi/changeOrderPaymentStatus/${orderId}/${orderPaymentStatus}',
      headers: {
        'token': jwtToken,
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).timeout(Duration(seconds: 300));

    final jsonResponse = json.decode(response.body);
    return jsonResponse;
  }

  Future<dynamic> deliveryTimeUpdate(
      String jwtToken, String deliveryTimeUpdateRequest) async {
    final http.Response response = await http
        .post(
            ServerConfig.SERVER_HOST +
                ServerConfig.SERVER_PORT.toString() +
                '/api/adminapi/deliveryTimeUpdate',
            headers: {
              'token': jwtToken,
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: deliveryTimeUpdateRequest)
        .timeout(Duration(seconds: 300));

    final jsonResponse = json.decode(response.body);
    return jsonResponse;
  }

  static OrderClient _instance;
  static OrderClient get instance => _instance ??= OrderClient();
}
