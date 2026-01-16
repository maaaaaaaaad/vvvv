import 'package:equatable/equatable.dart';

class CategorySummary extends Equatable {
  final String id;
  final String name;

  const CategorySummary({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}
