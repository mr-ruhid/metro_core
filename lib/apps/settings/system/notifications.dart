// lib/apps/settings/system/notifications.dart

import 'package:flutter/material.dart';
import '../../../ffi/system_ffi.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool _lockScreen = true;
  bool _banners = true;
  bool _alarms = true;
  Map<String, dynamic> _apps = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _lockScreen = SystemFFI.getLockScreenShow();
      _banners = SystemFFI.getBannersShow();
      _alarms = SystemFFI.getAlarmsShow();
      _apps = SystemFFI.getAppsList();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('notifications_text'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        color: Colors.black,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Lock screen
            _buildSwitchTile(
              icon: Icons.lock_outline,
              title: 'lock_screen_notifications_text',
              subtitle: 'show_on_lock_screen_text',
              value: _lockScreen,
              onChanged: (value) {
                setState(() => _lockScreen = value);
                SystemFFI.setLockScreenShow(value);
              },
            ),
            const Divider(color: Colors.grey),

            // Banners
            _buildSwitchTile(
              icon: Icons.notifications_active,
              title: 'banner_notifications_text',
              subtitle: 'show_banners_text',
              value: _banners,
              onChanged: (value) {
                setState(() => _banners = value);
                SystemFFI.setBannersShow(value);
              },
            ),
            const Divider(color: Colors.grey),

            // Alarms
            _buildSwitchTile(
              icon: Icons.alarm,
              title: 'alarms_reminders_text',
              subtitle: 'show_alarms_text',
              value: _alarms,
              onChanged: (value) {
                setState(() => _alarms = value);
                SystemFFI.setAlarmsShow(value);
              },
            ),
            const Divider(color: Colors.grey),

            const SizedBox(height: 16),
            const Text(
              'app_notifications_text',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // App list
            ..._apps.entries.map((entry) {
              return _buildAppTile(
                appName: entry.key,
                enabled: entry.value as bool,
                onChanged: (value) {
                  setState(() {
                    _apps[entry.key] = value;
                  });
                  SystemFFI.setAppEnabled(entry.key, value);
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.deepPurple),
          title: Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
          subtitle: Text(
            subtitle,
            style: const TextStyle(color: Colors.grey),
          ),
          trailing: Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.deepPurple,
          ),
        ),
      ],
    );
  }

  Widget _buildAppTile({
    required String appName,
    required bool enabled,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: Colors.grey[900],
      child: ListTile(
        leading: const Icon(Icons.apps, color: Colors.deepPurple),
        title: Text(
          appName,
          style: const TextStyle(color: Colors.white),
        ),
        trailing: Switch(
          value: enabled,
          onChanged: onChanged,
          activeColor: Colors.deepPurple,
        ),
      ),
    );
  }
}