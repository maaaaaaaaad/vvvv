import 'package:jellomark_mobile_owner/features/review/domain/entities/review.dart';

class ReviewModel extends Review {
  const ReviewModel({
    required super.id,
    required super.content,
    required super.rating,
    required super.memberNickname,
    required super.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] as String,
      content: json['content'] as String,
      rating: json['rating'] as int,
      memberNickname: json['memberNickname'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'rating': rating,
      'memberNickname': memberNickname,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Review toEntity() {
    return Review(
      id: id,
      content: content,
      rating: rating,
      memberNickname: memberNickname,
      createdAt: createdAt,
    );
  }
}
