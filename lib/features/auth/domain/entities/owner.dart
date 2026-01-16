import 'package:equatable/equatable.dart';

class Owner extends Equatable {
  final String id;
  final String nickname;
  final String email;
  final String businessNumber;
  final String phoneNumber;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Owner({
    required this.id,
    required this.nickname,
    required this.email,
    required this.businessNumber,
    required this.phoneNumber,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        nickname,
        email,
        businessNumber,
        phoneNumber,
        createdAt,
        updatedAt,
      ];
}
