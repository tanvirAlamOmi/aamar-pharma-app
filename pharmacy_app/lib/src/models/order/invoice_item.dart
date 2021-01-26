import 'package:pharmacy_app/src/models/order/deliver_address_details.dart';
import 'package:pharmacy_app/src/models/user/user_details.dart';

class InvoiceItem {
  String itemName;
  int itemUnitPrice;
  int itemQuantity;

  InvoiceItem({this.itemName, this.itemUnitPrice, this.itemQuantity});
}
