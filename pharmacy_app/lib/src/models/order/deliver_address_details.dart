import 'dart:convert';

class DeliveryAddressDetails {
  int id;
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

  String toJsonString() {
    final data = Map<String, dynamic>();
    data['id'] = id;
    data['area'] = area;
    data['add_type'] = addType;
    data['address'] = address;

    return json.encode(data);
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
