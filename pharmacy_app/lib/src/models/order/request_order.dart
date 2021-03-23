import 'dart:convert';

import 'package:pharmacy_app/src/models/general/Client_Enum.dart';

class RequestOrder {
  int id;
  String itemName;
  int quantity;
  String image;

  RequestOrder({this.id, this.itemName, this.image, this.quantity});

  factory RequestOrder.fromJson(Map<String, dynamic> jsonData) {
    return RequestOrder(
      id: jsonData['id'],
      itemName: jsonData['item_name'],
      quantity: jsonData['quantity'],
      image: jsonData['image'],
    );
  }

  String toJsonEncodedString() {
    return jsonEncode(<String, dynamic>{
      'id': id,
      'item_name': itemName,
      'quantity': quantity,
      'image': image,
    });
  }
}
