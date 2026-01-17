class UpdateTreatmentRequest {
  final String? name;
  final String? description;
  final int? price;
  final int? duration;
  final String? imageUrl;

  const UpdateTreatmentRequest({
    this.name,
    this.description,
    this.price,
    this.duration,
    this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};

    if (name != null) {
      json['name'] = name;
    }
    if (description != null) {
      json['description'] = description;
    }
    if (price != null) {
      json['price'] = price;
    }
    if (duration != null) {
      json['duration'] = duration;
    }
    if (imageUrl != null) {
      json['imageUrl'] = imageUrl;
    }

    return json;
  }
}
