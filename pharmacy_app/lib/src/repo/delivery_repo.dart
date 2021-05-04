import 'dart:convert';
import 'package:pharmacy_app/src/client/delivery_client.dart';
import 'package:pharmacy_app/src/client/order_client.dart';
import 'package:pharmacy_app/src/models/general/Client_Enum.dart';
import 'package:pharmacy_app/src/models/order/deliver_address_details.dart';
import 'package:pharmacy_app/src/models/order/delivery_charge.dart';
import 'package:pharmacy_app/src/models/order/order.dart';
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

  Future<Tuple2<void, String>> addDeliveryAddress(
      {DeliveryAddressDetails deliveryAddressDetails}) async {
    int retry = 0;
    while (retry++ < 2) {
      try {
        String jwtToken = Store.instance.appState.user.loginToken;

        final String addDeliveryAddressRequest = jsonEncode(<String, dynamic>{
          'add_type': deliveryAddressDetails.addType,
          'address': deliveryAddressDetails.address,
          'area': deliveryAddressDetails.area,
        });

        final addDeliveryAddressResponse = await DeliveryRepo.instance
            .getDeliveryClient()
            .addDeliveryAddress(jwtToken, addDeliveryAddressRequest);

        if (addDeliveryAddressResponse['result'] ==
            ClientEnum.RESPONSE_SUCCESS) {
          final int addressId = addDeliveryAddressResponse['id'];
          deliveryAddressDetails.id = addressId;

          Store.instance.setDeliveryAddress(deliveryAddressDetails);

          return Tuple2(null, ClientEnum.RESPONSE_SUCCESS);
        }
      } catch (err) {
        print("Error in addDeliveryAddress() in DeliveryRepo");
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
        String jwtToken = Store.instance.appState.user.loginToken;
        int customerId = Store.instance.appState.user.id;

        final deliveryAddressListResponse = await DeliveryRepo.instance
            .getDeliveryClient()
            .deliveryAddressListCustomer(jwtToken, customerId);

        final List<DeliveryAddressDetails> itemList = List<dynamic>.from(
                deliveryAddressListResponse.map((singleItem) =>
                    DeliveryAddressDetails.fromJson(singleItem)))
            .cast<DeliveryAddressDetails>();

        return Tuple2(itemList, ClientEnum.RESPONSE_SUCCESS);
      } catch (err) {
        print("Error in addDeliveryAddress() in DeliveryRepo");
        print(err);
      }
    }
    return Tuple2(null, ClientEnum.RESPONSE_CONNECTION_ERROR);
  }

  Future<Tuple2<List<DeliveryAddressDetails>, String>>
      coveredDeliveryPlaces() async {
    int retry = 0;
    while (retry++ < 2) {
      try {
        String jwtToken = Store.instance.appState.user.loginToken;

        final deliveryAddressListResponse = await DeliveryRepo.instance
            .getDeliveryClient()
            .coveredDeliveryPlaces(jwtToken);

        final List<DeliveryAddressDetails> itemList = List<dynamic>.from(
                deliveryAddressListResponse.map((singleItem) =>
                    DeliveryAddressDetails.fromJson(singleItem)))
            .cast<DeliveryAddressDetails>();

        return Tuple2(itemList, ClientEnum.RESPONSE_SUCCESS);
      } catch (err) {
        print("Error in coveredDeliveryPlaces() in DeliveryRepo");
        print(err);
      }
    }
    return Tuple2(null, ClientEnum.RESPONSE_CONNECTION_ERROR);
  }

  Future<List<DeliveryCharge>> deliveryCharges() async {
    int retry = 0;
    while (retry++ < 2) {
      try {
        String jwtToken = Store.instance.appState.user.loginToken;

        final getDeliveryChargeResponse = await DeliveryRepo.instance
            .getDeliveryClient()
            .deliveryCharges(jwtToken);

        if (!(getDeliveryChargeResponse is List))
          return defaultDeliveryCharge();

        final List<DeliveryCharge> itemList = List<dynamic>.from(
                getDeliveryChargeResponse
                    .map((singleItem) => DeliveryCharge.fromJson(singleItem)))
            .cast<DeliveryCharge>();

        return itemList;
      } catch (err) {
        print("Error in deliveryCharges() in DeliveryRepo");
        print(err);
        return defaultDeliveryCharge();
      }
    }
    return defaultDeliveryCharge();
  }

  List<DeliveryCharge> defaultDeliveryCharge() {
    return [
      DeliveryCharge()
        ..amountFrom = 0
        ..amountTo = '499.9999'
        ..deliveryCharge = 20,
      DeliveryCharge()
        ..amountFrom = 500
        ..amountTo = '999999999999'
        ..deliveryCharge = 0,
    ];
  }
}
