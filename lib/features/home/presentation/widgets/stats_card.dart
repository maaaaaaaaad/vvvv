import 'package:flutter/material.dart';

class StatsCard extends StatelessWidget {
  final int reviewCount;
  final double averageRating;
  final int treatmentCount;

  static const Color _pastelPink = Color(0xFFFFB5BA);

  const StatsCard({
    super.key,
    required this.reviewCount,
    required this.averageRating,
    required this.treatmentCount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStatItem(
              icon: Icons.reviews,
              iconColor: _pastelPink,
              value: reviewCount.toString(),
              label: '리뷰 수',
            ),
            _buildStatItem(
              icon: Icons.star,
              iconColor: Colors.amber,
              value: averageRating.toStringAsFixed(1),
              label: '평균 별점',
            ),
            _buildStatItem(
              icon: Icons.content_cut,
              iconColor: _pastelPink,
              value: treatmentCount.toString(),
              label: '시술 수',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: iconColor,
          size: 28,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
