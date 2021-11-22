import 'dart:convert';

class DeliveryCharge {
  double amountFrom;
  double amountTo; // This is needed when fetching all covered area of delivery
  int deliveryCharge;

  DeliveryCharge({
    this.amountFrom,
    this.amountTo,
    this.deliveryCharge,
  });

  factory DeliveryCharge.fromJson(Map<String, dynamic> jsonData) {
    return DeliveryCharge(
      amountFrom: double.parse(jsonData['amount_from']),
      amountTo: double.parse(jsonData['amount_to']),
      deliveryCharge: jsonData['delivery_charge'],
    );
  }

  String toJsonEncodedString() {
    return jsonEncode(<String, dynamic>{
      'amount_from': amountFrom,
      'amount_to': amountTo,
      'delivery_charge': deliveryCharge,
    });
  }
}
