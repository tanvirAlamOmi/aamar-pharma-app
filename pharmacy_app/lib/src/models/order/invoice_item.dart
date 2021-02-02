import 'dart:convert';

import 'package:pharmacy_app/src/models/general/Enum_Data.dart';

class InvoiceItem {
  String itemName;
  int itemQuantity;
  int itemUnitPrice;

  InvoiceItem({this.itemName, this.itemUnitPrice, this.itemQuantity});

  factory InvoiceItem.fromJson(Map<String, dynamic> jsonData) {
    return InvoiceItem(
      itemName: jsonData['item_name'],
      itemQuantity: jsonData['quantity'],
      itemUnitPrice: double.parse(jsonData['rate']).toInt(),
    );
  }

  String toJsonEncodedString() {
    return jsonEncode(<String, dynamic>{
      'item_name': itemName,
      'quantity': itemQuantity.toString(),
      'rate': itemUnitPrice.toString(),
      'unit': ClientEnum.NA,
      'image': ClientEnum.NA,
    });
  }
}
