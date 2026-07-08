import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Settings page — demonstrates sub-routes and ?tab= query param.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Read query param from URL: /home/profile/settings?tab=...
    final tab =
        GoRouterState.of(context).uri.queryParameters['tab'] ?? 'general';

    return DefaultTabController(
      length: 2,
      initialIndex: tab == 'notifications' ? 1 : 0,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Settings'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => context.canPop() ? context.pop() : null,
          ),
          bottom: const TabBar(
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            tabs: [
              Tab(text: 'General'),
              Tab(text: 'Notifications'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _GeneralSettings(activeTab: tab),
            _NotificationSettings(activeTab: tab),
          ],
        ),
      ),
    );
  }
}

class _GeneralSettings extends StatelessWidget {
  const _GeneralSettings({required this.activeTab});
  final String activeTab;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        if (activeTab == 'general')
          _ConceptBadge(
            'Active via ?tab=general',
            color: AppColors.primary,
          ),
        const SizedBox(height: 16),
        _SettingsSwitch(label: 'Dark Mode', value: true, onChanged: (_) {}),
        _SettingsSwitch(label: 'Compact Mode', value: false, onChanged: (_) {}),
        _SettingsSwitch(
            label: 'Analytics', value: true, onChanged: (_) {}),
      ],
    );
  }
}

class _NotificationSettings extends StatelessWidget {
  const _NotificationSettings({required this.activeTab});
  final String activeTab;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        if (activeTab == 'notifications')
          _ConceptBadge(
            'Active via ?tab=notifications',
            color: AppColors.secondary,
          ),
        const SizedBox(height: 16),
        _SettingsSwitch(
            label: 'Push Notifications', value: true, onChanged: (_) {}),
        _SettingsSwitch(
            label: 'Email Notifications', value: false, onChanged: (_) {}),
        _SettingsSwitch(
            label: 'Marketing Emails', value: false, onChanged: (_) {}),
      ],
    );
  }
}

class _ConceptBadge extends StatelessWidget {
  const _ConceptBadge(this.text, {required this.color});
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Icon(Icons.link_rounded, color: color, size: 14),
          const SizedBox(width: 8),
          Text(text,
              style: AppTextStyles.caption.copyWith(color: color)),
        ],
      ),
    );
  }
}

class _SettingsSwitch extends StatefulWidget {
  const _SettingsSwitch({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  State<_SettingsSwitch> createState() => _SettingsSwitchState();
}

class _SettingsSwitchState extends State<_SettingsSwitch> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: SwitchListTile(
        title: Text(widget.label, style: AppTextStyles.bodyLarge),
        value: _value,
        activeThumbColor: AppColors.primary,
        onChanged: (v) => setState(() => _value = v),
      ),
    );
  }
}
