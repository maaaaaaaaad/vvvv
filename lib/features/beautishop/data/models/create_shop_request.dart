class CreateShopRequest {
  final String shopName;
  final String shopRegNum;
  final String shopPhoneNumber;
  final String shopAddress;
  final double latitude;
  final double longitude;
  final Map<String, String> operatingTime;
  final String? shopDescription;
  final String? shopImage;

  const CreateShopRequest({
    required this.shopName,
    required this.shopRegNum,
    required this.shopPhoneNumber,
    required this.shopAddress,
    required this.latitude,
    required this.longitude,
    required this.operatingTime,
    this.shopDescription,
    this.shopImage,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'shopName': shopName,
      'shopRegNum': shopRegNum,
      'shopPhoneNumber': shopPhoneNumber,
      'shopAddress': shopAddress,
      'latitude': latitude,
      'longitude': longitude,
      'operatingTime': operatingTime,
    };

    if (shopDescription != null) {
      json['shopDescription'] = shopDescription;
    }
    if (shopImage != null) {
      json['shopImage'] = shopImage;
    }

    return json;
  }
}
