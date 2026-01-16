import 'package:jellomark_mobile_owner/features/auth/domain/entities/owner.dart';

class OwnerModel extends Owner {
  const OwnerModel({
    required super.id,
    required super.nickname,
    required super.email,
    required super.businessNumber,
    required super.phoneNumber,
    required super.createdAt,
    required super.updatedAt,
  });

  factory OwnerModel.fromJson(Map<String, dynamic> json) {
    return OwnerModel(
      id: json['id'] as String,
      nickname: json['nickname'] as String,
      email: json['email'] as String,
      businessNumber: json['businessNumber'] as String,
      phoneNumber: json['phoneNumber'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nickname': nickname,
      'email': email,
      'businessNumber': businessNumber,
      'phoneNumber': phoneNumber,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
