class OrderManualItem {
  String itemName;
  String itemUnit;
  String itemQuantity;

  OrderManualItem({
    this.itemName,
    this.itemUnit,
    this.itemQuantity,
  });

  factory OrderManualItem.fromJson(Map<String, dynamic> jsonData) {
    return OrderManualItem(
      itemName: jsonData['item_name'],
      itemUnit: jsonData['value'],
      itemQuantity: jsonData['quantity'],
    );
  }

  Map<String, dynamic> toJsonMap() {
    final data = Map<String, dynamic>();
    data['item_name'] = itemName;
    data['value'] = itemUnit;
    data['quantity'] = itemQuantity;

    return data;
  }
}
