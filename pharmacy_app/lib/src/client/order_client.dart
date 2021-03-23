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

  Future<dynamic> confirmInvoiceOrderResponse(
      String jwtToken, String confirmInvoiceOrderItemListRequest) async {
    final http.Response response = await http
        .post(
            ServerConfig.SERVER_HOST +
                ServerConfig.SERVER_PORT.toString() +
                '/api/appapi/invoice-confirm',
            headers: {
              'token': jwtToken,
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: confirmInvoiceOrderItemListRequest)
        .timeout(Duration(seconds: 300));

    final jsonResponse = json.decode(response.body);
    return jsonResponse;
  }

  Future<dynamic> cancelOrder(
      String jwtToken, String orderCancelRequest) async {
    final http.Response response = await http
        .post(
            ServerConfig.SERVER_HOST +
                ServerConfig.SERVER_PORT.toString() +
                '/api/appapi/cancelorder',
            headers: {
              'token': jwtToken,
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: orderCancelRequest)
        .timeout(Duration(seconds: 300));

    final jsonResponse = json.decode(response.body);
    return jsonResponse;
  }

  Future<dynamic> allowRepeatOrder(
      String jwtToken, int orderId, String allowRepeatOrderRequest) async {
    final http.Response response = await http
        .post(
            ServerConfig.SERVER_HOST +
                ServerConfig.SERVER_PORT.toString() +
                '/api/appapi/repeat-order/${orderId}',
            headers: {
              'token': jwtToken,
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: allowRepeatOrderRequest)
        .timeout(Duration(seconds: 300));

    final jsonResponse = json.decode(response.body);
    return jsonResponse;
  }

  Future<dynamic> cancelRepeatOrder(
      String jwtToken, String repeatOrderCancelRequest) async {
    final http.Response response = await http
        .post(
            ServerConfig.SERVER_HOST +
                ServerConfig.SERVER_PORT.toString() +
                '/api/appapi/cancelrepeat',
            headers: {
              'token': jwtToken,
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: repeatOrderCancelRequest)
        .timeout(Duration(seconds: 300));

    final jsonResponse = json.decode(response.body);
    return jsonResponse;
  }

  Future<dynamic> specialRequestOrder(
      String jwtToken, String specialRequestOrderProductRequest) async {
    final http.Response response = await http
        .post(
            ServerConfig.SERVER_HOST +
                ServerConfig.SERVER_PORT.toString() +
                '/api/appapi/request-product',
            headers: {
              'token': jwtToken,
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: specialRequestOrderProductRequest)
        .timeout(Duration(seconds: 300));

    final jsonResponse = json.decode(response.body);
    return jsonResponse;
  }

  Future<dynamic> singleOrder(String jwtToken, int orderId) async {
    final http.Response response = await http.get(
      ServerConfig.SERVER_HOST +
          ServerConfig.SERVER_PORT.toString() +
          '/api/appapi/order-details/${orderId}',
      headers: {
        'token': jwtToken,
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).timeout(Duration(seconds: 300));

    final jsonResponse = json.decode(response.body);
    return jsonResponse;
  }

  Future<dynamic> consultPharmacistOrder(
      String jwtToken, String consultPharmacistOrderRequest) async {
    final http.Response response = await http
        .post(
            ServerConfig.SERVER_HOST +
                ServerConfig.SERVER_PORT.toString() +
                '/api/appapi/consult-pharmacist',
            headers: {
              'token': jwtToken,
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: consultPharmacistOrderRequest)
        .timeout(Duration(seconds: 300));

    final jsonResponse = json.decode(response.body);
    return jsonResponse;
  }

  Future<dynamic> notifyOnDeliveryArea(
      String jwtToken, String notifyOnDeliveryAreaRequest) async {
    final http.Response response = await http
        .post(
        ServerConfig.SERVER_HOST +
            ServerConfig.SERVER_PORT.toString() +
            '/api/appapi/notify-delivery-area',
        headers: {
          'token': jwtToken,
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: notifyOnDeliveryAreaRequest)
        .timeout(Duration(seconds: 300));

    final jsonResponse = json.decode(response.body);
    return jsonResponse;
  }

  static OrderClient _instance;
  static OrderClient get instance => _instance ??= OrderClient();
}
