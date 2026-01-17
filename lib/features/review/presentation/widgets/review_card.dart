import 'package:flutter/material.dart';
import 'package:jellomark_mobile_owner/features/review/domain/entities/review.dart';

class ReviewCard extends StatelessWidget {
  final Review review;

  const ReviewCard({
    super.key,
    required this.review,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  review.memberNickname,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  _formatDate(review.createdAt),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: _buildStarRating(review.rating),
            ),
            const SizedBox(height: 12),
            Text(
              review.content,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final year = date.year.toString();
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year.$month.$day';
  }

  List<Widget> _buildStarRating(int rating) {
    return List.generate(5, (index) {
      if (index < rating) {
        return const Icon(
          Icons.star,
          color: Colors.amber,
          size: 20,
        );
      } else {
        return const Icon(
          Icons.star_border,
          color: Colors.amber,
          size: 20,
        );
      }
    });
  }
}
