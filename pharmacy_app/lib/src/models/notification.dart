import 'package:pharmacy_app/src/models/order/deliver_address_details.dart';
import 'package:pharmacy_app/src/models/user/user_details.dart';

class NotificationItem {
  int id;
  int idOrder;
  int idCustomer;
  String message;
  String status;

  NotificationItem({this.id,this.idOrder,this.idCustomer,this.message,this.status});

  factory NotificationItem.fromJson(Map<String, dynamic> jsonData) {
    return NotificationItem(
      id: jsonData['id'],
      idOrder: jsonData['id_order'],
      idCustomer: jsonData['id_customer'],
      message: jsonData['message'],
      status: jsonData['status'],
    );
  }
}
