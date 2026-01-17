import 'package:flutter/material.dart';
import 'package:jellomark_mobile_owner/shared/theme/app_colors.dart';
import 'package:jellomark_mobile_owner/shared/theme/app_gradients.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _pushNotificationEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        leading: const BackButton(),
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppGradients.softWhiteGradient),
        child: SafeArea(
          child: ListView(
            children: [
              _buildSectionHeader('알림 설정'),
              _buildPushNotificationTile(),
              const SizedBox(height: 16),
              _buildSectionHeader('테마'),
              _buildDarkModeTile(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary.withValues(alpha: 0.6),
        ),
      ),
    );
  }

  Widget _buildPushNotificationTile() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Icon(
          Icons.notifications_outlined,
          color: AppColors.pastelPink,
        ),
        title: const Text(
          '푸시 알림',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Switch(
          value: _pushNotificationEnabled,
          onChanged: (value) {
            setState(() {
              _pushNotificationEnabled = value;
            });
          },
          activeTrackColor: AppColors.pastelPink.withValues(alpha: 0.5),
          activeThumbColor: AppColors.pastelPink,
        ),
      ),
    );
  }

  Widget _buildDarkModeTile() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Icon(
          Icons.dark_mode_outlined,
          color: AppColors.textPrimary.withValues(alpha: 0.4),
        ),
        title: Text(
          '다크 모드',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary.withValues(alpha: 0.4),
          ),
        ),
        subtitle: Text(
          '추후 지원 예정',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textPrimary.withValues(alpha: 0.3),
          ),
        ),
        enabled: false,
      ),
    );
  }
}
