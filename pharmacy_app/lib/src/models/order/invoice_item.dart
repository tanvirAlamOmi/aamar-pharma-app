import 'dart:convert';

import 'package:pharmacy_app/src/models/general/Enum_Data.dart';

class InvoiceItem {
  String itemName;
  int itemUnitPrice;
  int itemQuantity;

  InvoiceItem({this.itemName, this.itemUnitPrice, this.itemQuantity});

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
