import 'package:flutter/material.dart';
import 'package:jellomark_mobile_owner/shared/theme/app_colors.dart';

class OwnerBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const OwnerBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: AppColors.pastelPink,
      unselectedItemColor: Colors.grey,
      backgroundColor: Colors.white,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '홈',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.store),
          label: '내 샵',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.content_cut),
          label: '시술',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.more_horiz),
          label: '더보기',
        ),
      ],
    );
  }
}
