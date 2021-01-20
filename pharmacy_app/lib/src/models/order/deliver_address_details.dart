class DeliveryAddressDetails {
  String id;
  String area;
  String addType; // Address Type: Home, Office
  String address;

  DeliveryAddressDetails({
    this.id,
    this.addType,
    this.address,
    this.area,
  });

  factory DeliveryAddressDetails.fromJson(Map<String, dynamic> jsonData) {
    return DeliveryAddressDetails(
      id: jsonData['id'],
      area: jsonData['area'],
      addType: jsonData['add_type'],
      address: jsonData['address'],
    );
  }

  Map<String, dynamic> toJsonMap() {
    final data = Map<String, dynamic>();
    data['id'] = id;
    data['area'] = area;
    data['add_type'] = addType;
    data['address'] = address;

    return data;
  }
}
