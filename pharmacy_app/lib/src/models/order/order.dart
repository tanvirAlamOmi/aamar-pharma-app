import 'dart:convert';
import 'package:pharmacy_app/src/models/order/invoice.dart';
import 'package:pharmacy_app/src/models/order/order_manual_item.dart';

class Order {
  String id;
  String idCustomer;
  String idAddress;
  String prescription; // All Images with comma separated
  List<OrderManualItem> items;
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
  Invoice invoice;

  Order(
      {this.id,
      this.idCustomer,
      this.idAddress,
      this.prescription,
      this.items,
      this.name,
      this.email,
      this.mobileNo,
      this.note,
      this.repeatOrder,
      this.deliveryTime,
      this.deliveryDate,
      this.createdAt,
      this.status,
      this.rejectionReason,
      this.orderWith,
      this.every,
      this.day,
      this.time,
      this.invoice});

  factory Order.fromJson(Map<String, dynamic> jsonData) {
    return Order(
      id: jsonData['id'],
      idCustomer: jsonData['id_customer'],
      idAddress: jsonData['id_address'],
      prescription: jsonData['prescription'],
      items: jsonData['items'],
      name: jsonData['name'],
      email: jsonData['email'],
      mobileNo: jsonData['mobile_no'],
      note: jsonData['note'],
      repeatOrder: jsonData['repeat_order'],
      deliveryTime: jsonData['delivery_time'],
      deliveryDate: jsonData['delivery_date'],
      createdAt: jsonData['created_at'],
      status: jsonData['status'],
      rejectionReason: jsonData['rejection_reason'],
      orderWith: jsonData['order_with'],
      every: jsonData['every'],
      day: jsonData['day'],
      time: jsonData['time'],
    );
  }

  String toJsonString() {
    final data = Map<String, dynamic>();
    data['id'] = id;
    data['id_customer'] = idCustomer;
    data['id_address'] = idAddress;
    data['prescription'] = prescription;
    data['items'] = items;
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
