import 'package:pharmacy_app/src/models/order/deliver_address_details.dart';
import 'package:pharmacy_app/src/models/order/invoice.dart';
import 'package:pharmacy_app/src/models/user/user_details.dart';

class Order {
  String id;
  String orderType;
  String orderStatus;
  List<dynamic> imageList;
  List<dynamic> itemList;
  DeliveryAddressDetails deliveryAddressDetails;
  UserDetails userDetails;
  Invoice invoice;

  Order(
      {this.id,
      this.orderType,
      this.orderStatus,
      this.imageList,
      this.itemList,
      this.deliveryAddressDetails,
      this.userDetails,
      this.invoice});

  factory Order.fromJson(Map<String, dynamic> jsonData) {
    return Order(
      id: jsonData['id'],
      orderType: jsonData['order_type'],
      orderStatus: jsonData['order_status'],
    );
  }
}
