import 'package:pharmacy_app/src/models/order/deliver_address_details.dart';
import 'package:pharmacy_app/src/models/user/user_details.dart';

class InvoiceItem {
  String itemName;
  String itemUnitPrice;
  String itemQuantity;

  InvoiceItem({this.itemName, this.itemUnitPrice, this.itemQuantity});
}
