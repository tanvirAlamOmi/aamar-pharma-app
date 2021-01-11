import 'package:pharmacy_app/src/models/order/deliver_address_details.dart';
import 'package:pharmacy_app/src/models/user/user.dart';

class AppState {
  User user = new User();
  List<DeliveryAddressDetails> allDeliveryAddress =
      new List<DeliveryAddressDetails>();
  String firebasePushNotificationToken = "";
  int initialTutorialScrollingPage = 0;
  int tutorialBoxNumberHomePage = 0;
  int tutorialBoxNumberAddItemsPage = 0;

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
    initialTutorialScrollingPage = 0;
    tutorialBoxNumberHomePage = 0;
    tutorialBoxNumberAddItemsPage = 0;
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
    data['INITIAL_TUTORIAL_SCROLLING_PAGE'] = initialTutorialScrollingPage;
    data['TUTORIAL_BOX_NUMBER_HOME_PAGE'] = tutorialBoxNumberHomePage;
    data['TUTORIAL_BOX_NUMBER_ADD_ITEMS_PAGE'] = tutorialBoxNumberAddItemsPage;

    return data;
  }
}
