import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jellomark_mobile_owner/shared/theme/app_colors.dart';

class MainShell extends ConsumerStatefulWidget {
  final String? shopId;
  final String? shopName;

  const MainShell({
    super.key,
    this.shopId,
    this.shopName,
  });

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  int _currentIndex = 0;

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _navigateToShopTab() {
    setState(() {
      _currentIndex = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildHomeTab(),
          _buildMyShopTab(),
          _buildTreatmentsTab(),
          _buildMoreTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabSelected,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.pastelPink,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store_outlined),
            activeIcon: Icon(Icons.store),
            label: '내 샵',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.spa_outlined),
            activeIcon: Icon(Icons.spa),
            label: '시술',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            activeIcon: Icon(Icons.more_horiz),
            label: '더보기',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeTab() {
    if (widget.shopId == null) {
      return _buildNoShopPlaceholder();
    }
    return _buildHomeTabPlaceholder();
  }

  Widget _buildNoShopPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.store_outlined,
            size: 64,
            color: AppColors.pastelPink.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            '샵을 먼저 등록해주세요',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '샵을 등록하면 대시보드를 확인할 수 있습니다',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _navigateToShopTab,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.pastelPink,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('샵 등록하러 가기'),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeTabPlaceholder() {
    return Center(
      child: Text(
        'HomeTab: ${widget.shopName}',
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildMyShopTab() {
    return const Center(
      child: Text(
        'MyShopTab Placeholder',
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildTreatmentsTab() {
    return const Center(
      child: Text(
        'TreatmentsTab Placeholder',
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildMoreTab() {
    return const Center(
      child: Text(
        'MoreTab Placeholder',
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
