import 'dart:convert';

class DeliveryCharge {
  int amountFrom;
  double amountTo; // This is needed when fetching all covered area of delivery
  int deliveryCharge;

  DeliveryCharge({
    this.amountFrom,
    this.amountTo,
    this.deliveryCharge,
  });

  factory DeliveryCharge.fromJson(Map<String, dynamic> jsonData) {
    return DeliveryCharge(
      amountFrom: jsonData['amount_from'],
      amountTo: jsonData['amount_to'],
      deliveryCharge: jsonData['delivery_charge'],
    );
  }
}
