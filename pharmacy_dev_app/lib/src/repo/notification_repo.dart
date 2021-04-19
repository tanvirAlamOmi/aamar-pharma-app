import 'dart:convert';
import 'package:pharmacy_app/src/client/delivery_client.dart';
import 'package:pharmacy_app/src/client/notification_client.dart';
import 'package:pharmacy_app/src/client/order_client.dart';
import 'package:pharmacy_app/src/models/general/Client_Enum.dart';
import 'package:pharmacy_app/src/models/order/deliver_address_details.dart';
import 'package:pharmacy_app/src/models/order/order.dart';
import 'package:pharmacy_app/src/store/store.dart';
import 'package:tuple/tuple.dart';

class NotificationRepo {
  NotificationClient _notificationClient;

  NotificationClient getNotificationClient() {
    if (_notificationClient == null)
      _notificationClient = new NotificationClient();
    return _notificationClient;
  }

  static final NotificationRepo _instance = NotificationRepo();

  static NotificationRepo get instance => _instance;

  Future<Tuple2<int, String>> notificationCount() async {
    int retry = 0;
    while (retry++ < 2) {
      try {
        String jwtToken = Store.instance.appState.user.loginToken;
        final int userId = Store.instance.appState.user.id;

        if (userId == null) return Tuple2(0, ClientEnum.RESPONSE_SUCCESS);

        final notificationCountResponse = await NotificationRepo.instance
            .getNotificationClient()
            .notificationCount(jwtToken);

        if (notificationCountResponse['result'] ==
            ClientEnum.RESPONSE_SUCCESS) {
          final int totalNotification =
              notificationCountResponse['notification'];
          return Tuple2(totalNotification, ClientEnum.RESPONSE_SUCCESS);
        } else {
          return Tuple2(0, notificationCountResponse['result']);
        }
      } catch (err) {
        print("Error in notificationCount() in NotificationRepo");
        print(err);
      }
    }
    return Tuple2(0, ClientEnum.RESPONSE_CONNECTION_ERROR);
  }

  Future<Tuple2<void, String>> changeNotificationStatus(
      {int id, String notificationStatus}) async {
    int retry = 0;
    while (retry++ < 2) {
      try {
        String jwtToken = Store.instance.appState.user.loginToken;

        final String changeNotificationStatusRequest =
            jsonEncode(<String, dynamic>{
          'id': id,
          'status': notificationStatus,
        });

        final changeNotificationStatusResponse = await NotificationRepo.instance
            .getNotificationClient()
            .changeNotificationStatus(
                jwtToken, changeNotificationStatusRequest);

        if (changeNotificationStatusResponse['result'] ==
            ClientEnum.RESPONSE_SUCCESS) {
          return Tuple2(null, ClientEnum.RESPONSE_SUCCESS);
        } else {
          return Tuple2(null, changeNotificationStatusResponse['result']);
        }
      } catch (err) {
        print("Error in changeNotificationStatus() in NotificationRepo");
        print(err);
      }
    }
    return Tuple2(null, ClientEnum.RESPONSE_CONNECTION_ERROR);
  }
}
