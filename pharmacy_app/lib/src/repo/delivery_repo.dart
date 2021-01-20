import 'dart:convert';

import 'package:pharmacy_app/src/client/delivery_client.dart';
import 'package:pharmacy_app/src/client/order_client.dart';
import 'package:pharmacy_app/src/models/general/Enum_Data.dart';
import 'package:pharmacy_app/src/models/order/deliver_address_details.dart';
import 'package:pharmacy_app/src/models/order/order.dart';
import 'package:pharmacy_app/src/models/order/order_item.dart';
import 'package:pharmacy_app/src/store/store.dart';
import 'package:tuple/tuple.dart';

class DeliveryRepo {
  DeliveryClient _deliveryClient;

  DeliveryClient getDeliveryClient() {
    if (_deliveryClient == null) _deliveryClient = new DeliveryClient();
    return _deliveryClient;
  }

  static final DeliveryRepo _instance = DeliveryRepo();

  static DeliveryRepo get instance => _instance;

  Future<Tuple2<List<OrderItem>, String>> addDeliveryAddress(
      DeliveryAddressDetails deliveryAddressDetails) async {
    int retry = 0;
    while (retry++ < 2) {
      try {
        String jwtToken = Store.instance.appState.user.token;

        final String addDeliveryAddressRequest = jsonEncode(<String, dynamic>{
          'id_customer': Store.instance.appState.user.id,
          'apt_no': ClientEnum.NA,
          'house_no': ClientEnum.NA,
          'street': ClientEnum.NA,
          'area': deliveryAddressDetails.area,
          'city': ClientEnum.NA,
        });

        final addDeliveryAddressResponse = await DeliveryRepo.instance
            .getDeliveryClient()
            .addDeliveryAddress(jwtToken, addDeliveryAddressRequest);

        return Tuple2(null, ClientEnum.RESPONSE_SUCCESS);
      } catch (err) {
        print("Error in addDeliveryAddress() in OrderRepo");
        print(err);
      }
    }
    return Tuple2(null, ClientEnum.RESPONSE_CONNECTION_ERROR);
  }

  Future<Tuple2<List<DeliveryAddressDetails>, String>>
      deliveryAddressListCustomer(
          DeliveryAddressDetails deliveryAddressDetails) async {
    int retry = 0;
    while (retry++ < 2) {
      try {
        String jwtToken = Store.instance.appState.user.token;
        String customerId = Store.instance.appState.user.id;

        final deliveryAddressListResponse = await DeliveryRepo.instance
            .getDeliveryClient()
            .deliveryAddressListCustomer(jwtToken, customerId);

        final List<DeliveryAddressDetails> itemList = List<dynamic>.from(
                deliveryAddressListResponse.map((singleItem) =>
                    DeliveryAddressDetails.fromJson(singleItem)))
            .cast<DeliveryAddressDetails>();

        return Tuple2(itemList, ClientEnum.RESPONSE_SUCCESS);
      } catch (err) {
        print("Error in addDeliveryAddress() in OrderRepo");
        print(err);
      }
    }
    return Tuple2(null, ClientEnum.RESPONSE_CONNECTION_ERROR);
  }
}
