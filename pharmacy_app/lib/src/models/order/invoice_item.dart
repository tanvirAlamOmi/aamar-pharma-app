import 'dart:convert';

import 'package:pharmacy_app/src/models/general/Enum_Data.dart';

class InvoiceItem {
  String itemName;
  String unit;
  int quantity;
  int rate;
  String isPrescriptionRequired;

  InvoiceItem(
      {this.itemName,
      this.unit,
      this.rate,
      this.quantity,
      this.isPrescriptionRequired});

  factory InvoiceItem.fromJson(Map<String, dynamic> jsonData) {
    return InvoiceItem(
      itemName: jsonData['item_name'],
      unit: jsonData['unit'],
      quantity: jsonData['quantity'],
      rate: double.parse(jsonData['rate']).toInt(),
      isPrescriptionRequired: jsonData['is_prescription_required'],
    );
  }

  String toJsonEncodedString() {
    return jsonEncode(<String, dynamic>{
      'item_name': itemName,
      'unit': unit,
      'quantity': quantity.toString(),
      'rate': rate.toString(),
      'image': ClientEnum.NA,
      'is_prescription_required': isPrescriptionRequired,
    });
  }
}
