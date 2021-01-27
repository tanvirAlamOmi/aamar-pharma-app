import 'dart:convert';

class InvoiceItem {
  String itemName;
  int itemUnitPrice;
  int itemQuantity;

  InvoiceItem({this.itemName, this.itemUnitPrice, this.itemQuantity});

  String toJsonEncodedString() {
    return jsonEncode(<String, dynamic>{
      'item_name': itemName,
      'item_unit_price': itemUnitPrice,
      'item_quantity': itemQuantity
    });
  }
}
