import 'dart:convert';

class OrderManualItem {
  String itemName;
  String unit;
  int quantity;
  String unitType;

  OrderManualItem(
      {this.itemName, this.unit, this.quantity, this.unitType});

  factory OrderManualItem.fromJson(Map<String, dynamic> jsonData) {
    return OrderManualItem(
        itemName: jsonData['item_name'],
        unit: jsonData['unit'],
        quantity: jsonData['quantity'],
        unitType: jsonData['unit_type']);
  }

  String toJsonEncodedString() {
    return jsonEncode(<String, dynamic>{
      'id_order': 0,
      'item_name': itemName,
      'unit': unit,
      'image': 'N/A',
      'quantity': quantity,
      'unit_type': unitType
    });
  }
}
