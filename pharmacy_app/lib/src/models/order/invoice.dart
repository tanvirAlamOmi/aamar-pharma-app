import 'package:pharmacy_app/src/models/order/deliver_address_details.dart';
import 'package:pharmacy_app/src/models/order/invoice_item.dart';
import 'package:pharmacy_app/src/models/order/order_manual_item.dart';
import 'package:pharmacy_app/src/models/user/user_details.dart';

class Invoice {
  List<InvoiceItem> invoiceItemList;

  Invoice({this.invoiceItemList});
}
