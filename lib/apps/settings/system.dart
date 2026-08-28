// lib/apps/settings/system.dart
import 'package:flutter/material.dart';
import 'setting_search.dart';
import 'system/display.dart';
import 'system/notifications.dart';
import 'system/phone.dart';
import 'system/storage.dart';
import 'system/wireless_display.dart';
import 'system/about_page.dart';
import 'system/battery_saver.dart';
import 'system/charge.dart';
import 'system/device_encryption_page.dart';

class SystemSettingsPage extends StatefulWidget {
  const SystemSettingsPage({super.key});

  @override
  State<SystemSettingsPage> createState() => _SystemSettingsPageState();
}

class _SystemSettingsPageState extends State<SystemSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('system_settings', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Axtarış düyməsi
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingSearch()),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1F1F1F),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey),
                    SizedBox(width: 10),
                    Text('search_hint', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildSettingItem(context, 'display_title', const DisplayPage()),
                  _buildSettingItem(context, 'notifications_title', const NotificationsPage()),
                  _buildSettingItem(context, 'phone_title', const PhonePage()),
                  _buildSettingItem(context, 'storage_title', const StoragePage()),
                  _buildSettingItem(context, 'wireless_display_title', const WirelessDisplayPage()),
                  _buildSettingItem(context, 'battery_saver_title', const BatterySaverPage()),
                  _buildSettingItem(context, 'charge_title', const ChargePage()),
                  _buildSettingItem(context, 'device_encryption_title', const DeviceEncryptionPage()),
                  _buildSettingItem(context, 'about_title', const AboutPage()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(BuildContext context, String key, Widget page) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: const Icon(Icons.settings, color: Colors.cyanAccent),
        title: Text(key, style: const TextStyle(color: Colors.white)),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
      ),
    );
  }
}