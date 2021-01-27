import 'dart:convert';
import 'package:pharmacy_app/src/client/delivery_client.dart';
import 'package:pharmacy_app/src/client/notification_client.dart';
import 'package:pharmacy_app/src/client/order_client.dart';
import 'package:pharmacy_app/src/models/general/Enum_Data.dart';
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
        String jwtToken = Store.instance.appState.user.token;
        int customerId = Store.instance.appState.user.id;

        final notificationCountResponse = await NotificationRepo.instance
            .getNotificationClient()
            .notificationCount(jwtToken, customerId);

        if (notificationCountResponse['result'] ==
            ClientEnum.RESPONSE_SUCCESS) {
          final int totalNotification =
              notificationCountResponse['NOTIFICATION'];
          return Tuple2(totalNotification, ClientEnum.RESPONSE_SUCCESS);
        } else {
          return Tuple2(null, notificationCountResponse['result']);
        }
      } catch (err) {
        print("Error in notificationCount() in NotificationRepo");
        print(err);
      }
    }
    return Tuple2(null, ClientEnum.RESPONSE_CONNECTION_ERROR);
  }
}
