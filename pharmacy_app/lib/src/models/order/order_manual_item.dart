class OrderManualItem {
  String itemName;
  String unit;
  int quantity;

  OrderManualItem({
    this.itemName,
    this.unit,
    this.quantity,
  });

  factory OrderManualItem.fromJson(Map<String, dynamic> jsonData) {
    return OrderManualItem(
      itemName: jsonData['item_name'],
      unit: jsonData['unit'],
      quantity: jsonData['quantity'],
    );
  }

  Map<String, dynamic> toJsonMap() {
    final data = Map<String, dynamic>();
    data['item_name'] = itemName;
    data['unit'] = unit;
    data['quantity'] = quantity;

    return data;
  }
}
