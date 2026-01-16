import 'package:jellomark_mobile_owner/features/beautishop/data/models/category_summary_model.dart';
import 'package:jellomark_mobile_owner/features/beautishop/domain/entities/beautishop.dart';

class BeautishopModel extends Beautishop {
  const BeautishopModel({
    required super.id,
    required super.name,
    required super.regNum,
    required super.phoneNumber,
    required super.address,
    required super.latitude,
    required super.longitude,
    required super.operatingTime,
    super.description,
    super.image,
    required super.averageRating,
    required super.reviewCount,
    required super.categories,
    super.distance,
    required super.createdAt,
    required super.updatedAt,
  });

  factory BeautishopModel.fromJson(Map<String, dynamic> json) {
    final categoriesJson = json['categories'] as List<dynamic>? ?? [];
    final categories = categoriesJson
        .map((c) => CategorySummaryModel.fromJson(c as Map<String, dynamic>))
        .toList();

    final operatingTimeJson = json['operatingTime'] as Map<String, dynamic>? ?? {};
    final operatingTime = operatingTimeJson.map(
      (key, value) => MapEntry(key, value as String),
    );

    return BeautishopModel(
      id: json['id'] as String,
      name: json['name'] as String,
      regNum: json['regNum'] as String,
      phoneNumber: json['phoneNumber'] as String,
      address: json['address'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      operatingTime: operatingTime,
      description: json['description'] as String?,
      image: json['image'] as String?,
      averageRating: (json['averageRating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      categories: categories,
      distance: (json['distance'] as num?)?.toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'regNum': regNum,
      'phoneNumber': phoneNumber,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'operatingTime': operatingTime,
      'description': description,
      'image': image,
      'averageRating': averageRating,
      'reviewCount': reviewCount,
      'categories': categories
          .map((c) => (c as CategorySummaryModel).toJson())
          .toList(),
      'distance': distance,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
