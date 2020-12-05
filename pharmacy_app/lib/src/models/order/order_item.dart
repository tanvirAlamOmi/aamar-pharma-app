class OrderItem {
  String itemName;
  String value;
  String quantity;
  String rate;
  String itemTotal;

  OrderItem({
    this.itemName,
    this.value,
    this.quantity,
    this.rate,
    this.itemTotal,
  });

  factory OrderItem.fromJson(Map<String, dynamic> jsonData) {
    return OrderItem(
      itemName: jsonData['item_name'],
      value: jsonData['value'],
      quantity: jsonData['quantity'],
      rate: jsonData['rate'],
      itemTotal: jsonData['item_total'],
    );
  }

  Map<String, dynamic> toJsonMap() {
    final data = Map<String, dynamic>();
    data['item_name'] = itemName;
    data['value'] = value;
    data['quantity'] = quantity;
    data['rate'] = rate;
    data['item_total'] = itemTotal;

    return data;
  }
}
