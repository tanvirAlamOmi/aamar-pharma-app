import 'dart:convert';
import 'package:pharmacy_app/src/models/order/invoice_item.dart';
import 'package:pharmacy_app/src/models/order/order_manual_item.dart';

class Order {
  int id;
  int idCustomer;
  int idAddress;
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
  String orderedWith; // Order Type. List of Prescription or Items
  String every; // Repeat Order -  Month, Week or 15 days.
  String day; // Repeat Order - Saturday, Sunday...
  String time; // Repeat Order - time
  String nextOrderDay; // Repeat Order - Next Delivery Date
  List<InvoiceItem> invoiceItemList;

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
      this.orderedWith,
      this.every,
      this.day,
      this.time,
      this.nextOrderDay,
      this.invoiceItemList});

  factory Order.fromJson(Map<String, dynamic> jsonData) {
    return Order(
      id: jsonData['id'],
      idCustomer: jsonData['id_customer'],
      idAddress: jsonData['id_address'],
      prescription: jsonData['prescription'],
      items: (jsonData['items'] == null)
          ? null
          : jsonData['items']
              .map((singleManualItem) =>
                  OrderManualItem.fromJson(singleManualItem))
              .toList()
              .cast<OrderManualItem>(),
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
      orderedWith: jsonData['ordered_with'],
      every: jsonData['every'],
      day: jsonData['day'],
      time: jsonData['time'],
      nextOrderDay: jsonData['nextOrderDay'],
      invoiceItemList: (jsonData['invoice'] == null)
          ? null
          : jsonData['invoice']
              .map((singleInvoiceItem) =>
                  InvoiceItem.fromJson(singleInvoiceItem))
              .toList()
              .cast<InvoiceItem>(),
    );
  }

  String toJsonEncodedString() {
    return jsonEncode(<String, dynamic>{
      'id': id,
      'id_customer': idCustomer,
      'id_address': idAddress,
      'prescription': prescription,
      'items': (items == null)
          ? null
          : items
              .map((singleManualItem) => singleManualItem.toJsonEncodedString())
              .toList()
              .toString(),
      'name': name,
      'email': email,
      'mobile_no': mobileNo,
      'repeat_order': repeatOrder,
      'delivery_time': deliveryTime,
      'delivery_date': deliveryDate,
      'created_at': createdAt,
      'status': status,
      'rejection_reason': rejectionReason,
      'ordered_with': orderedWith,
      'every': every,
      'day': day,
      'time': time,
      'nextOrderDay': nextOrderDay,
      'invoice-items': (invoiceItemList == null)
          ? null
          : invoiceItemList
              .map((singleInvoiceItem) =>
                  singleInvoiceItem.toJsonEncodedString())
              .toList()
              .toString(),
    });
  }
}
