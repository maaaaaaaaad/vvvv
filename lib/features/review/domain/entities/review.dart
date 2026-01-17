import 'package:equatable/equatable.dart';

class Review extends Equatable {
  final String id;
  final String content;
  final int rating;
  final String memberNickname;
  final DateTime createdAt;

  const Review({
    required this.id,
    required this.content,
    required this.rating,
    required this.memberNickname,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        content,
        rating,
        memberNickname,
        createdAt,
      ];
}
