import 'package:pharmacy_app/src/models/order/deliver_address_details.dart';
import 'package:pharmacy_app/src/models/user/user.dart';

class AppState {
  User user = new User();
  List<DeliveryAddressDetails> allDeliveryAddress =
      new List<DeliveryAddressDetails>();
  String firebasePushNotificationToken = "";

  AppState() {}

  AppState.fromJsonMap(Map<String, dynamic> data) {
    user = User.fromJson(data['USER']);
    allDeliveryAddress = (data['branches'] == [])
        ? []
        : data['branches']
            .map((singleDeliveryAddress) =>
                DeliveryAddressDetails.fromJson(singleDeliveryAddress))
            .toList()
            .cast<DeliveryAddressDetails>();
    firebasePushNotificationToken = data['FIREBASE_PUSH_NOTIFICATION_TOKEN'];
  }

  Map<String, dynamic> toJsonMap() {
    final data = Map<String, dynamic>();
    data['USER'] = user.toJsonMap();
    data['branches'] = (allDeliveryAddress == null ||
            allDeliveryAddress.isEmpty)
        ? []
        : allDeliveryAddress
            .map((singleDeliveryAddress) => singleDeliveryAddress.toJsonMap())
            .toList();
    data['FIREBASE_PUSH_NOTIFICATION_TOKEN'] = firebasePushNotificationToken;

    return data;
  }
}
