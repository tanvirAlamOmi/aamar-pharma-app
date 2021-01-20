import 'dart:convert';

import 'package:pharmacy_app/src/models/order/deliver_address_details.dart';
import 'package:pharmacy_app/src/models/order/invoice.dart';
import 'package:pharmacy_app/src/models/user/user.dart';
import 'package:pharmacy_app/src/models/user/user_details.dart';

class Order {
  String id;
  String idCustomer;
  String idAddress;
  String prescription; // All Images with comma separated
  String name;
  String email;
  String mobileNo;
  String note;
  String repeatOrder;
  String deliveryTime;
  String deliveryDate;
  String createdAt;
  String status; // Order Status
  String rejectionReason;
  String orderWith; // Order Type. List of Prescription or Items
  String every; // Repeat Order -  Month, Week or 15 days.
  String day; // Repeat Order - Saturday, Sunday...
  String time; // Repeat Order - time

  // My custom defined
  List<dynamic> imageList;
  List<dynamic> itemList;
  DeliveryAddressDetails deliveryAddressDetails;
  User user;
  Invoice invoice;

  Order(
      {this.id,
      this.orderWith,
      this.status,
      this.imageList,
      this.itemList,
      this.deliveryAddressDetails,
      this.user,
      this.repeatOrder,
      this.invoice});

  factory Order.fromJson(Map<String, dynamic> jsonData) {
    return Order(
      id: jsonData['id'],
      orderWith: jsonData['order_type'],
      status: jsonData['order_status'],
    );
  }

  String toJsonString() {
    final data = Map<String, dynamic>();
    data['id'] = id;
    data['id_customer'] = idCustomer;
    data['id_address'] = idAddress;
    data['prescription'] = prescription;
    data['name'] = name;
    data['email'] = email;
    data['mobile_no'] = mobileNo;
    data['note'] = note;
    data['repeat_order'] = repeatOrder;
    data['delivery_time'] = deliveryTime;
    data['delivery_date'] = deliveryDate;
    data['created_at'] = createdAt;
    data['status'] = status;
    data['rejection_reason'] = rejectionReason;
    data['ordered_with'] = orderWith;
    data['every'] = every;
    data['day'] = day;
    data['time'] = time;

    return json.encode(data);
  }
}

// import 'package:pharmacy_app/src/models/order/deliver_address_details.dart';
// import 'package:pharmacy_app/src/models/order/invoice.dart';
// import 'package:pharmacy_app/src/models/user/user.dart';
// import 'package:pharmacy_app/src/models/user/user_details.dart';
//
// class Order {
//   String id;
//   String idCustomer;
//   String idAddress;
//   String orderType;
//   String orderStatus;
//   List<dynamic> imageList;
//   List<dynamic> itemList;
//   DeliveryAddressDetails deliveryAddressDetails;
//   User user;
//   String repeatOrder;
//   Invoice invoice;
//
//   Order(
//       {this.id,
//         this.orderType,
//         this.orderStatus,
//         this.imageList,
//         this.itemList,
//         this.deliveryAddressDetails,
//         this.user,
//         this.repeatOrder,
//         this.invoice});
//
//   factory Order.fromJson(Map<String, dynamic> jsonData) {
//     return Order(
//       id: jsonData['id'],
//       orderType: jsonData['order_type'],
//       orderStatus: jsonData['order_status'],
//     );
//   }
// }
