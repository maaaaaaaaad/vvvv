class UpdateShopRequest {
  final Map<String, String>? operatingTime;
  final String? shopDescription;
  final String? shopImage;

  const UpdateShopRequest({
    this.operatingTime,
    this.shopDescription,
    this.shopImage,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};

    if (operatingTime != null) {
      json['operatingTime'] = operatingTime;
    }
    if (shopDescription != null) {
      json['shopDescription'] = shopDescription;
    }
    if (shopImage != null) {
      json['shopImage'] = shopImage;
    }

    return json;
  }
}
