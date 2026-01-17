class CreateTreatmentRequest {
  final String name;
  final String? description;
  final int price;
  final int duration;
  final String? imageUrl;

  const CreateTreatmentRequest({
    required this.name,
    this.description,
    required this.price,
    required this.duration,
    this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'name': name,
      'price': price,
      'duration': duration,
    };

    if (description != null) {
      json['description'] = description;
    }
    if (imageUrl != null) {
      json['imageUrl'] = imageUrl;
    }

    return json;
  }
}
