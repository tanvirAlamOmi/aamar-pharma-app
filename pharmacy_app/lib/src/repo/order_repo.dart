import 'dart:convert';

import 'package:pharmacy_app/src/client/order_client.dart';
import 'package:pharmacy_app/src/models/general/Enum_Data.dart';
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

        final orderWithPrescriptionResponse = await OrderRepo.instance
            .getOrderClient()
            .orderWithPrescription(jwtToken, order.toJsonEncodedString());

        if (orderWithPrescriptionResponse['result'] ==
            ClientEnum.RESPONSE_SUCCESS) {
          return Tuple2(null, ClientEnum.RESPONSE_SUCCESS);
        } else {
          return Tuple2(null, orderWithPrescriptionResponse['result']);
        }
      } catch (err) {
        print("Error in orderWithPrescription() in OrderRepo");
        print(err);
      }
    }
    return Tuple2(null, ClientEnum.RESPONSE_CONNECTION_ERROR);
  }

  Future<Tuple2<void, String>> orderWithItemName({Order order}) async {
    int retry = 0;
    while (retry++ < 2) {
      try {
        String jwtToken = Store.instance.appState.user.token;

        final orderWithItemNameResponse = await OrderRepo.instance
            .getOrderClient()
            .orderWithItems(jwtToken, order.toJsonEncodedString());

        if (orderWithItemNameResponse['result'] ==
            ClientEnum.RESPONSE_SUCCESS) {
          return Tuple2(null, ClientEnum.RESPONSE_SUCCESS);
        } else {
          return Tuple2(null, orderWithItemNameResponse['result']);
        }
      } catch (err) {
        print("Error in orderWithItemName() in OrderRepo");
        print(err);
      }
    }
    return Tuple2(null, ClientEnum.RESPONSE_CONNECTION_ERROR);
  }

  Future<Tuple2<void, String>> cancelOrder({int orderId}) async {
    int retry = 0;
    while (retry++ < 2) {
      try {
        String jwtToken = Store.instance.appState.user.token;

        final cancelOrderRequest =
            jsonEncode(<String, dynamic>{'id_order': orderId});

        final cancelOrderResponse = await OrderRepo.instance
            .getOrderClient()
            .cancelOrder(jwtToken, cancelOrderRequest);

        if (cancelOrderResponse['result'] == ClientEnum.RESPONSE_SUCCESS) {
          return Tuple2(null, ClientEnum.RESPONSE_SUCCESS);
        } else {
          return Tuple2(null, cancelOrderResponse['result']);
        }
      } catch (err) {
        print("Error in cancelOrder() in OrderRepo");
        print(err);
      }
    }
    return Tuple2(null, ClientEnum.RESPONSE_CONNECTION_ERROR);
  }

  Future<Tuple2<void, String>> confirmInvoiceOrder({Order order}) async {
    int retry = 0;
    while (retry++ < 2) {
      try {
        String jwtToken = Store.instance.appState.user.token;

        final confirmInvoiceOrderResponse = await OrderRepo.instance
            .getOrderClient()
            .confirmInvoiceOrderResponse(jwtToken, order.toJsonEncodedString());

        if (confirmInvoiceOrderResponse['result'] ==
            ClientEnum.RESPONSE_SUCCESS) {
          return Tuple2(null, ClientEnum.RESPONSE_SUCCESS);
        } else {
          return Tuple2(null, confirmInvoiceOrderResponse['result']);
        }
      } catch (err) {
        print("Error in confirmInvoiceOrderResponse() in OrderRepo");
        print(err);
      }
    }
    return Tuple2(null, ClientEnum.RESPONSE_CONNECTION_ERROR);
  }

  Future<Tuple2<void, String>> cancelRepeatOrder({int orderId}) async {
    int retry = 0;
    while (retry++ < 2) {
      try {
        String jwtToken = Store.instance.appState.user.token;

        final cancelRepeatOrderRequest =
            jsonEncode(<String, dynamic>{'id_order': orderId});

        final cancelRepeatOrderResponse = await OrderRepo.instance
            .getOrderClient()
            .cancelRepeatOrder(jwtToken, cancelRepeatOrderRequest);

        if (cancelRepeatOrderResponse['result'] ==
            ClientEnum.RESPONSE_SUCCESS) {
          return Tuple2(null, ClientEnum.RESPONSE_SUCCESS);
        } else {
          return Tuple2(null, cancelRepeatOrderResponse['result']);
        }
      } catch (err) {
        print("Error in cancelRepeatOrder() in OrderRepo");
        print(err);
      }
    }
    return Tuple2(null, ClientEnum.RESPONSE_CONNECTION_ERROR);
  }
}
