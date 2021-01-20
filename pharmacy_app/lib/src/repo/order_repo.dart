import 'dart:convert';

import 'package:pharmacy_app/src/client/order_client.dart';
import 'package:pharmacy_app/src/models/general/Enum_Data.dart';
import 'package:pharmacy_app/src/models/general/Order_Enum.dart';
import 'package:pharmacy_app/src/models/order/order.dart';
import 'package:pharmacy_app/src/models/order/order_item.dart';
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

  Future<Tuple2<List<OrderItem>, String>> getOrderItems(
      int orderItemsById) async {
    int retry = 0;
    while (retry++ < 2) {
      try {
        String jwtToken = Store.instance.appState.user.token;

        final orderItemsResponse = await OrderRepo.instance
            .getOrderClient()
            .getOrderItems(jwtToken, orderItemsById);

        final List<OrderItem> itemList = List<dynamic>.from(orderItemsResponse
                .map((singleItem) => OrderItem.fromJson(singleItem)))
            .cast<OrderItem>();

        return Tuple2(itemList, ClientEnum.RESPONSE_SUCCESS);
      } catch (err) {
        print("Error in getOrderItems() in OrderRepo");
        print(err);
      }
    }
    return Tuple2(null, ClientEnum.RESPONSE_CONNECTION_ERROR);
  }

  Future<Tuple2<void, String>> changeOrderStatus(
      String orderId, String orderStatus) async {
    int retry = 0;
    while (retry++ < 2) {
      try {
        String jwtToken = Store.instance.appState.user.token;

        final changeOrderStatusResponse = await OrderRepo.instance
            .getOrderClient()
            .changeOrderStatus(jwtToken, orderId, orderStatus);

        if (changeOrderStatusResponse['result'] ==
            ClientEnum.RESPONSE_SUCCESS) {
          return Tuple2(null, ClientEnum.RESPONSE_SUCCESS);
        }
        if (changeOrderStatusResponse['result'] == ClientEnum.RESPONSE_FAIL) {
          return Tuple2(null, changeOrderStatusResponse['RESPONSE_MESSAGE']);
        }
      } catch (err) {
        print("Error in changeOrderStatus() in OrderRepo");
        print(err);
      }
    }
    return Tuple2(null, ClientEnum.RESPONSE_CONNECTION_ERROR);
  }

  Future<Tuple2<void, String>> changeOrderPaymentStatus(String orderId) async {
    int retry = 0;
    while (retry++ < 2) {
      try {
        String jwtToken = Store.instance.appState.user.token;

        final changeOrderStatusResponse = await OrderRepo.instance
            .getOrderClient()
            .changeOrderPaymentStatus(
                jwtToken, orderId, OrderEnum.ORDER_PAYMENT_STATUS_PAID);

        if (changeOrderStatusResponse['result'] ==
            ClientEnum.RESPONSE_SUCCESS) {
          return Tuple2(null, ClientEnum.RESPONSE_SUCCESS);
        }
        if (changeOrderStatusResponse['result'] == ClientEnum.RESPONSE_FAIL) {
          return Tuple2(null, changeOrderStatusResponse['RESPONSE_MESSAGE']);
        }
      } catch (err) {
        print("Error in changeOrderPaymentStatus() in OrderRepo");
        print(err);
      }
    }
    return Tuple2(null, ClientEnum.RESPONSE_CONNECTION_ERROR);
  }

  Future<Tuple2<void, String>> deliveryTimeUpdate(
      { String orderStatus, Order order}) async {
    int retry = 0;
    while (retry++ < 2) {
      try {
        String jwtToken = Store.instance.appState.user.token;

        final String deliveryTimeUpdateRequest = jsonEncode(<String, dynamic>{
          'id': order.id,
        });

        final deliveryTimeUpdateResponse = await OrderRepo.instance
            .getOrderClient()
            .deliveryTimeUpdate(jwtToken, deliveryTimeUpdateRequest);

        if (deliveryTimeUpdateResponse['result'] ==
            ClientEnum.RESPONSE_SUCCESS) {
          return Tuple2(null, ClientEnum.RESPONSE_SUCCESS);
        }
        if (deliveryTimeUpdateResponse['result'] == ClientEnum.RESPONSE_FAIL) {
          return Tuple2(null, deliveryTimeUpdateResponse['RESPONSE_MESSAGE']);
        }
      } catch (err) {
        print("Error in changeOrderPaymentStatus() in OrderRepo");
        print(err);
      }
    }
    return Tuple2(null, ClientEnum.RESPONSE_CONNECTION_ERROR);
  }
}
