import 'package:jellomark_mobile_owner/core/network/api_client.dart';
import 'package:jellomark_mobile_owner/features/review/data/models/paged_reviews_model.dart';

abstract class ReviewRemoteDataSource {
  Future<PagedReviewsModel> getShopReviews(
    String shopId, {
    int page,
    int size,
  });
}

class ReviewRemoteDataSourceImpl implements ReviewRemoteDataSource {
  final ApiClient apiClient;

  ReviewRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<PagedReviewsModel> getShopReviews(
    String shopId, {
    int page = 0,
    int size = 10,
  }) async {
    final response = await apiClient.dio.get(
      '/api/beautishops/$shopId/reviews',
      queryParameters: {'page': page, 'size': size},
    );
    return PagedReviewsModel.fromJson(response.data as Map<String, dynamic>);
  }
}
