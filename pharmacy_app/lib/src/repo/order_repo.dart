import 'dart:convert';

import 'package:pharmacy_app/src/client/order_client.dart';
import 'package:pharmacy_app/src/models/general/Enum_Data.dart';
import 'package:pharmacy_app/src/models/general/Order_Enum.dart';
import 'package:pharmacy_app/src/models/order/order.dart';
import 'package:pharmacy_app/src/store/store.dart';
import 'package:tuple/tuple.dart';

class OrderRepo {
  OrderClient _orderClient;

  OrderClient getOrderClient() {
    if (_orderClient == null) _orderClient = new OrderClient();
    return _orderClient;
  }

  static final OrderRepo _instance = OrderRepo();

  static OrderRepo get instance => _instance;

  Future<Tuple2<void, String>> orderWithPrescription({Order order}) async {
    int retry = 0;
    while (retry++ < 2) {
      try {
        String jwtToken = Store.instance.appState.user.token;

        final String orderWithPrescriptionRequest = jsonEncode(<String, dynamic>{
          'apt_no': ClientEnum.NA,
          'house_no': ClientEnum.NA,
          'street': ClientEnum.NA,
          'city': ClientEnum.NA,
        });

        return Tuple2(null, ClientEnum.RESPONSE_SUCCESS);
      } catch (err) {
        print("Error in getOrderItems() in OrderRepo");
        print(err);
      }
    }
    return Tuple2(null, ClientEnum.RESPONSE_CONNECTION_ERROR);
  }
}
