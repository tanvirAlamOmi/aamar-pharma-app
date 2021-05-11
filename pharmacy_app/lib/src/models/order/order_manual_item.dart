import 'dart:convert';

class OrderManualItem {
  String itemName;
  String unit;
  int quantity;
  String itemContainerTypeChoice;

  OrderManualItem(
      {this.itemName, this.unit, this.quantity, this.itemContainerTypeChoice});

  factory OrderManualItem.fromJson(Map<String, dynamic> jsonData) {
    return OrderManualItem(
      itemName: jsonData['item_name'],
      unit: jsonData['unit'],
      quantity: jsonData['quantity'],
    );
  }

  String toJsonString() {
    final data = Map<String, dynamic>();
    data['item_name'] = itemName;
    data['unit'] = unit;
    data['quantity'] = quantity;
    return json.encode(data);
  }

  String toJsonEncodedString() {
    return jsonEncode(<String, dynamic>{
      'id_order': 0,
      'item_name': itemName,
      'unit': unit,
      'image': 'abc.jpg',
      'quantity': quantity,
    });
  }

  Map<String, dynamic> toJsonMap() {
    final data = Map<String, dynamic>();
    data['item_name'] = itemName;
    data['unit'] = unit;
    data['quantity'] = quantity;

    return data;
  }
}
