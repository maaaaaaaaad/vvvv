class SetCategoriesRequest {
  final List<String> categoryIds;

  const SetCategoriesRequest({required this.categoryIds});

  Map<String, dynamic> toJson() {
    return {
      'categoryIds': categoryIds,
    };
  }
}
