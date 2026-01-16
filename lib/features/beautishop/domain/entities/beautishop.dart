import 'package:equatable/equatable.dart';
import 'package:jellomark_mobile_owner/features/beautishop/domain/entities/category_summary.dart';

class Beautishop extends Equatable {
  final String id;
  final String name;
  final String regNum;
  final String phoneNumber;
  final String address;
  final double latitude;
  final double longitude;
  final Map<String, String> operatingTime;
  final String? description;
  final String? image;
  final double averageRating;
  final int reviewCount;
  final List<CategorySummary> categories;
  final double? distance;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Beautishop({
    required this.id,
    required this.name,
    required this.regNum,
    required this.phoneNumber,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.operatingTime,
    this.description,
    this.image,
    required this.averageRating,
    required this.reviewCount,
    required this.categories,
    this.distance,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        regNum,
        phoneNumber,
        address,
        latitude,
        longitude,
        operatingTime,
        description,
        image,
        averageRating,
        reviewCount,
        categories,
        distance,
        createdAt,
        updatedAt,
      ];
}
