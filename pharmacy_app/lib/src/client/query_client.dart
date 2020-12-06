import 'dart:convert';
import 'package:pharmacy_app/src/configs/server_config.dart';
import 'package:pharmacy_app/src/models/feed/feed_request.dart';
import 'package:http/http.dart' as http;

class QueryClient {
  QueryClient() {
    print("QueryClient Initialized");
  }

  Future<dynamic> getFeed(
      String jwtToken, FeedRequest feedRequest) async {
    final http.Response response = await http.get(
      ServerConfig.SERVER_HOST +
          ServerConfig.SERVER_PORT.toString() +
          '/api/adminapi/orders/${feedRequest.feedInfo.feedType}/',
      headers: {
        'token': jwtToken,
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).timeout(Duration(seconds: 300));

    final jsonResponse = json.decode(response.body);
    print("PRINT IN CLIENT");
    print(jsonResponse);
    return jsonResponse;
  }

  static QueryClient _instance;
  static QueryClient get instance => _instance ??= QueryClient();
}
