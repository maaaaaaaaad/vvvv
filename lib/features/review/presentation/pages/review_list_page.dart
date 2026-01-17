import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jellomark_mobile_owner/features/review/domain/entities/review.dart';
import 'package:jellomark_mobile_owner/features/review/presentation/providers/review_providers.dart';
import 'package:jellomark_mobile_owner/features/review/presentation/providers/review_state.dart';
import 'package:jellomark_mobile_owner/features/review/presentation/widgets/review_card.dart';
import 'package:jellomark_mobile_owner/features/review/presentation/widgets/review_stats_card.dart';

class ReviewListPage extends ConsumerStatefulWidget {
  final String shopId;

  const ReviewListPage({
    super.key,
    required this.shopId,
  });

  @override
  ConsumerState<ReviewListPage> createState() => _ReviewListPageState();
}

class _ReviewListPageState extends ConsumerState<ReviewListPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadReviews();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _loadReviews() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(reviewStateNotifierProvider.notifier).loadReviews(widget.shopId);
    });
  }

  void _onScroll() {
    if (_isNearBottom()) {
      _loadMoreReviews();
    }
  }

  bool _isNearBottom() {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    return currentScroll >= maxScroll * 0.7;
  }

  void _loadMoreReviews() {
    final state = ref.read(reviewStateNotifierProvider);
    if (state is ReviewLoaded || state is ReviewLoadedMore) {
      ref.read(reviewStateNotifierProvider.notifier).loadMoreReviews(widget.shopId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(reviewStateNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('리뷰'),
        backgroundColor: const Color(0xFFFFB5BA),
        foregroundColor: Colors.white,
      ),
      body: _buildBody(state),
    );
  }

  Widget _buildBody(ReviewState state) {
    return switch (state) {
      ReviewInitial() => _buildLoading(),
      ReviewLoading() => _buildLoading(),
      ReviewLoaded(:final reviews, :final totalCount, :final averageRating) =>
        _buildReviewList(reviews, totalCount, averageRating, false),
      ReviewLoadingMore() => _buildLoading(),
      ReviewLoadedMore(:final reviews, :final totalCount, :final averageRating) =>
        _buildReviewList(reviews, totalCount, averageRating, false),
      ReviewError(:final message) => _buildError(message),
    };
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(
        color: Color(0xFFFFB5BA),
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadReviews,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFB5BA),
              foregroundColor: Colors.white,
            ),
            child: const Text('다시 시도'),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewList(
    List<Review> reviews,
    int totalCount,
    double averageRating,
    bool isLoadingMore,
  ) {
    if (reviews.isEmpty) {
      return _buildEmpty();
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: reviews.length + 1 + (isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == 0) {
          return ReviewStatsCard(
            averageRating: averageRating,
            totalCount: totalCount,
          );
        }

        final reviewIndex = index - 1;
        if (reviewIndex < reviews.length) {
          return ReviewCard(review: reviews[reviewIndex]);
        }

        return const Padding(
          padding: EdgeInsets.all(16),
          child: Center(
            child: CircularProgressIndicator(
              color: Color(0xFFFFB5BA),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.rate_review_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            '아직 리뷰가 없습니다',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
