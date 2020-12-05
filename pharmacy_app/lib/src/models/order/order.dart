class Order {
  String id;
  String orderDate;
  String orderTime;
  String deliveryDateTime;
  String collectionDateTime;
  String orderType;
  String name;
  String mobile;
  String grandTotal;
  String paymentMethod;
  String paymentStatus;
  String orderStatus;
  String discount;
  String orderNote;
  String foodNote;
  String addressLine1;
  String addressLine2;
  String postCode;
  String city;

  Order({
    this.id,
    this.orderDate,
    this.orderTime,
    this.deliveryDateTime,
    this.collectionDateTime,
    this.orderType,
    this.name,
    this.mobile,
    this.grandTotal,
    this.paymentMethod,
    this.paymentStatus,
    this.orderStatus,
    this.discount,
    this.orderNote,
    this.foodNote,
    this.addressLine1,
    this.addressLine2,
    this.postCode,
    this.city,
  });

  factory Order.fromJson(Map<String, dynamic> jsonData) {
    return Order(
      id: jsonData['id'],
      orderDate: jsonData['order_date'],
      orderTime: jsonData['order_time'],
      deliveryDateTime: jsonData['delivery_date_time'],
      collectionDateTime: jsonData['collection_date_time'],
      orderType: jsonData['order_type'],
      name: jsonData['name'],
      mobile: jsonData['mobile'],
      grandTotal: jsonData['grandtotal'],
      paymentMethod: jsonData['payment_method'],
      paymentStatus: jsonData['payment_status'],
      orderStatus: jsonData['order_status'],
      discount: jsonData['discount'],
      orderNote: jsonData['order_note'],
      foodNote: jsonData['food_note'],
      addressLine1: jsonData['addressline1'],
      addressLine2: jsonData['addressline2'],
      postCode: jsonData['postcode'],
      city: jsonData['city'],
    );
  }

  Map<String, dynamic> toJsonMap() {
    final data = Map<String, dynamic>();
    data['id'] = id;
    data['order_date'] = orderDate;
    data['order_time'] = orderTime;
    data['delivery_date_time'] = deliveryDateTime;
    data['collection_date_time'] = collectionDateTime;
    data['order_type'] = orderType;
    data['name'] = name;
    data['mobile'] = mobile;
    data['grandtotal'] = grandTotal;
    data['payment_method'] = paymentMethod;
    data['payment_status'] = paymentStatus;
    data['order_status'] = orderStatus;
    data['discount'] = discount;
    data['order_note'] = orderNote;
    data['food_note'] = foodNote;
    data['addressline1'] = addressLine1;
    data['addressline2'] = addressLine2;
    data['postcode'] = postCode;
    data['city'] = city;

    return data;
  }
}
