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
        .post(ServerConfig.Address(path: '/api/appapi/addDeliveryAddress'),
            headers: {
              'token': jwtToken,
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: addDeliveryAddressRequest)
        .timeout(Duration(seconds: 300));

    final jsonResponse = json.decode(response.body);
    return jsonResponse;
  }

  Future<dynamic> deliveryAddressListCustomer(
      String jwtToken, int customerId) async {
    final http.Response response = await http.get(
      ServerConfig.Address(path: '/api/appapi/addresslist/${customerId}'),
      headers: {
        'token': jwtToken,
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).timeout(Duration(seconds: 300));

    final jsonResponse = json.decode(response.body);
    return jsonResponse;
  }

  Future<dynamic> coveredDeliveryPlaces(String jwtToken) async {
    final http.Response response = await http.get(
      ServerConfig.Address(path: '/api/appapi/area-covered'),
      headers: {
        'token': jwtToken,
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).timeout(Duration(seconds: 300));

    final jsonResponse = json.decode(response.body);
    return jsonResponse;
  }

  Future<dynamic> deliveryCharges(String jwtToken) async {
    final http.Response response = await http.get(
      ServerConfig.Address(path: '/api/appapi/delivery-charge'),
      headers: {
        'token': jwtToken,
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).timeout(Duration(seconds: 20));

    final jsonResponse = json.decode(response.body);
    return jsonResponse;
  }

  static DeliveryClient _instance;
  static DeliveryClient get instance => _instance ??= DeliveryClient();
}
