class DeliveryAddressDetails {
  String addressType;
  String fullAddress;
  String areaName;

  DeliveryAddressDetails({
    this.addressType,
    this.fullAddress,
    this.areaName,
  });

  factory DeliveryAddressDetails.fromJson(Map<String, dynamic> jsonData) {
    return DeliveryAddressDetails(
      addressType: jsonData['addressType'],
      fullAddress: jsonData['fullAddress'],
      areaName: jsonData['areaName'],
    );
  }

  Map<String, dynamic> toJsonMap() {
    final data = Map<String, dynamic>();
    data['addressType'] = addressType;
    data['fullAddress'] = fullAddress;
    data['areaName'] = areaName;
    return data;
  }
}
