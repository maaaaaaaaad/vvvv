import 'package:jellomark_mobile_owner/features/beautishop/domain/entities/category_summary.dart';

class CategorySummaryModel extends CategorySummary {
  const CategorySummaryModel({
    required super.id,
    required super.name,
  });

  factory CategorySummaryModel.fromJson(Map<String, dynamic> json) {
    return CategorySummaryModel(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
