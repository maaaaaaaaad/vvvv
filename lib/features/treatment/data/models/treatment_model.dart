import 'package:jellomark_mobile_owner/features/treatment/domain/entities/treatment.dart';

class TreatmentModel extends Treatment {
  const TreatmentModel({
    required super.id,
    required super.name,
    super.description,
    required super.price,
    required super.duration,
    super.imageUrl,
    required super.createdAt,
    required super.updatedAt,
  });

  factory TreatmentModel.fromJson(Map<String, dynamic> json) {
    return TreatmentModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      price: json['price'] as int,
      duration: json['duration'] as int,
      imageUrl: json['imageUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'duration': duration,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
