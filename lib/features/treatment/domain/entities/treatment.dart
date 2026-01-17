import 'package:equatable/equatable.dart';

class Treatment extends Equatable {
  final String id;
  final String name;
  final String? description;
  final int price;
  final int duration;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Treatment({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    required this.duration,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        price,
        duration,
        imageUrl,
        createdAt,
        updatedAt,
      ];
}
