import 'dart:convert';
import 'package:pharmacy_app/src/configs/server_config.dart';
import 'package:pharmacy_app/src/models/feed/feed_request.dart';
import 'package:http/http.dart' as http;

class QueryClient {
  QueryClient() {
    print("QueryClient Initialized");
  }

  Future<dynamic> getOrderFeed(
      String jwtToken, FeedRequest feedRequest, int userId) async {
    final http.Response response = await http.get(
      ServerConfig.SERVER_HOST +
          ServerConfig.SERVER_PORT.toString() +
          '/api/appapi/my-orders/${userId}/',
      headers: {
        'token': jwtToken,
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).timeout(Duration(seconds: 10));

    final jsonResponse = json.decode(response.body);
    return jsonResponse;
  }

  Future<dynamic> getRepeatOrderFeed(
      String jwtToken, FeedRequest feedRequest, int userId) async {
    final http.Response response = await http.get(
      ServerConfig.SERVER_HOST +
          ServerConfig.SERVER_PORT.toString() +
          '/api/appapi/repeat-orders/${userId}/',
      headers: {
        'token': jwtToken,
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).timeout(Duration(seconds: 300));

    final jsonResponse = json.decode(response.body);
    return jsonResponse;
  }

  Future<dynamic> getRequestOrderFeed(
      String jwtToken, FeedRequest feedRequest, int userId) async {
    final http.Response response = await http.get(
      ServerConfig.SERVER_HOST +
          ServerConfig.SERVER_PORT.toString() +
          '/api/appapi/request-list/${userId}/',
      headers: {
        'token': jwtToken,
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).timeout(Duration(seconds: 300));

    final jsonResponse = json.decode(response.body);
    return jsonResponse;
  }

  Future<dynamic> getNotificationsFeed(
      String jwtToken, FeedRequest feedRequest) async {
    final http.Response response = await http.post(
      ServerConfig.SERVER_HOST +
          ServerConfig.SERVER_PORT.toString() +
          '/api/appapi/notifications/',
      headers: {
        'token': jwtToken,
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).timeout(Duration(seconds: 300));

    final jsonResponse = json.decode(response.body);
    return jsonResponse;
  }

  static QueryClient _instance;
  static QueryClient get instance => _instance ??= QueryClient();
}
