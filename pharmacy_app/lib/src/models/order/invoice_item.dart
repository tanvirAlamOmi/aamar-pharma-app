import 'dart:convert';

import 'package:pharmacy_app/src/models/general/Client_Enum.dart';

class InvoiceItem {
  String itemName;
  String unit;
  int quantity;
  double rate;
  String unitType;
  dynamic itemDiscount; // Double or Int
  String isPrescriptionRequired;

  InvoiceItem(
      {this.itemName,
      this.unit,
      this.quantity,
      this.rate,
      this.unitType,
      this.itemDiscount,
      this.isPrescriptionRequired});

  factory InvoiceItem.fromJson(Map<String, dynamic> jsonData) {
    return InvoiceItem(
      itemName: jsonData['item_name'],
      unit: jsonData['unit'],
      quantity: jsonData['quantity'],
      rate: double.parse(jsonData['rate']),
      unitType: jsonData['unit_type'],
      itemDiscount: jsonData['item_discount'],
      isPrescriptionRequired: jsonData['is_prescription_required'],
    );
  }

  String toJsonEncodedString() {
    return jsonEncode(<String, dynamic>{
      'item_name': itemName,
      'unit': unit,
      'quantity': quantity.toString(),
      'rate': rate.toString(),
      'unit_type': unitType,
      'item_discount': itemDiscount.toString(),
      'image': ClientEnum.NA,
      'is_prescription_required': isPrescriptionRequired,
    });
  }
}
