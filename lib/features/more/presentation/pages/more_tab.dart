import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jellomark_mobile_owner/features/more/presentation/widgets/more_menu_item.dart';

class MoreTab extends ConsumerStatefulWidget {
  final VoidCallback onProfileTap;
  final VoidCallback onSettingsTap;
  final VoidCallback onAboutTap;
  final VoidCallback onLogout;

  const MoreTab({
    super.key,
    required this.onProfileTap,
    required this.onSettingsTap,
    required this.onAboutTap,
    required this.onLogout,
  });

  @override
  ConsumerState<MoreTab> createState() => _MoreTabState();
}

class _MoreTabState extends ConsumerState<MoreTab> {
  Future<void> _showLogoutDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('로그아웃 확인'),
        content: const Text('정말 로그아웃 하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('확인'),
          ),
        ],
      ),
    );

    if (result == true) {
      widget.onLogout();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader('내 정보'),
              MoreMenuItem(
                icon: Icons.person_outline,
                title: '내 정보 조회',
                onTap: widget.onProfileTap,
              ),
              _buildSectionHeader('설정'),
              MoreMenuItem(
                icon: Icons.settings_outlined,
                title: '설정',
                onTap: widget.onSettingsTap,
              ),
              MoreMenuItem(
                icon: Icons.info_outline,
                title: '앱 정보',
                onTap: widget.onAboutTap,
              ),
              _buildSectionHeader('계정'),
              MoreMenuItem(
                icon: Icons.logout,
                title: '로그아웃',
                onTap: _showLogoutDialog,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.grey[600],
        ),
      ),
    );
  }
}
