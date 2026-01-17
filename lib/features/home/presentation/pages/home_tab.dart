import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jellomark_mobile_owner/features/home/presentation/providers/dashboard_providers.dart';
import 'package:jellomark_mobile_owner/features/home/presentation/providers/dashboard_state.dart';
import 'package:jellomark_mobile_owner/features/home/presentation/widgets/quick_actions_section.dart';
import 'package:jellomark_mobile_owner/features/home/presentation/widgets/recent_reviews_section.dart';
import 'package:jellomark_mobile_owner/features/home/presentation/widgets/stats_card.dart';

class HomeTab extends ConsumerStatefulWidget {
  final String shopId;
  final String shopName;
  final VoidCallback onTreatmentTap;
  final VoidCallback onReviewTap;

  const HomeTab({
    super.key,
    required this.shopId,
    required this.shopName,
    required this.onTreatmentTap,
    required this.onReviewTap,
  });

  @override
  ConsumerState<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends ConsumerState<HomeTab> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => _loadDashboard());
  }

  void _loadDashboard() {
    ref
        .read(dashboardStateNotifierProvider.notifier)
        .loadDashboard(widget.shopId);
  }

  Future<void> _refresh() async {
    await ref
        .read(dashboardStateNotifierProvider.notifier)
        .refresh(widget.shopId);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dashboardStateNotifierProvider);

    return Scaffold(
      body: SafeArea(
        child: _buildBody(state),
      ),
    );
  }

  Widget _buildBody(DashboardState state) {
    return switch (state) {
      DashboardInitial() || DashboardLoading() => _buildLoading(),
      DashboardLoaded(:final stats) => _buildLoaded(stats),
      DashboardError(:final message) => _buildError(message),
    };
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildLoaded(dynamic stats) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeMessage(),
            const SizedBox(height: 16),
            StatsCard(
              reviewCount: stats.reviewCount,
              averageRating: stats.averageRating,
              treatmentCount: stats.treatmentCount,
            ),
            const SizedBox(height: 16),
            QuickActionsSection(
              onTreatmentTap: widget.onTreatmentTap,
              onReviewTap: widget.onReviewTap,
            ),
            const SizedBox(height: 16),
            RecentReviewsSection(reviews: stats.recentReviews),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeMessage() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '안녕하세요!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.shopName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
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
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadDashboard,
            child: const Text('다시 시도'),
          ),
        ],
      ),
    );
  }
}
