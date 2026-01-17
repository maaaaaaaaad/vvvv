import 'package:flutter/material.dart';
import 'package:jellomark_mobile_owner/features/review/domain/entities/review.dart';
import 'package:jellomark_mobile_owner/features/review/presentation/widgets/review_card.dart';

class RecentReviewsSection extends StatelessWidget {
  final List<Review> reviews;

  const RecentReviewsSection({
    super.key,
    required this.reviews,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            '최근 리뷰',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (reviews.isEmpty)
          const Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: Text(
                '아직 리뷰가 없습니다',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ),
          )
        else
          ...reviews.map((review) => ReviewCard(review: review)),
      ],
    );
  }
}
