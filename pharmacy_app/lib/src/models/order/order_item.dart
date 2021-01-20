class OrderItem {
  String id;
  String orderId;
  String itemName;
  String unit;
  String quantity;
  String rate;
  String itemTotal;

  OrderItem({
    this.id,
    this.orderId,
    this.itemName,
    this.unit,
    this.quantity,
    this.rate,
    this.itemTotal,
  });

  factory OrderItem.fromJson(Map<String, dynamic> jsonData) {
    return OrderItem(
      id: jsonData['id'],
      orderId: jsonData['order_id'],
      itemName: jsonData['item_name'],
      unit: jsonData['unit'],
      quantity: jsonData['quantity'],
      rate: jsonData['rate'],
      itemTotal: jsonData['item_total'],
    );
  }

  Map<String, dynamic> toJsonMap() {
    final data = Map<String, dynamic>();
    data['id'] = id;
    data['order_id'] = orderId;
    data['item_name'] = itemName;
    data['unit'] = unit;
    data['quantity'] = quantity;
    data['rate'] = rate;
    data['item_total'] = itemTotal;

    return data;
  }
}
