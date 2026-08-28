// lib/apps/settings/setting_search.dart
import 'package:flutter/material.dart';
import 'system/display.dart';
import 'system/notifications.dart';
import 'system/phone.dart';
import 'system/storage.dart';
import 'system/wireless_display.dart';
import 'system/about_page.dart';
import 'system/battery_saver.dart';
import 'system/charge.dart';
import 'system/device_encryption_page.dart';

class SettingSearch extends StatefulWidget {
  const SettingSearch({super.key});

  @override
  State<SettingSearch> createState() => _SettingSearchState();
}

class _SettingSearchState extends State<SettingSearch> {
  final List<Map<String, dynamic>> _allSettings = [
    {'key': 'display_title', 'label': 'Display', 'page': const DisplayPage()},
    {'key': 'notifications_title', 'label': 'Notifications', 'page': const NotificationsPage()},
    {'key': 'phone_title', 'label': 'Phone', 'page': const PhonePage()},
    {'key': 'storage_title', 'label': 'Storage', 'page': const StoragePage()},
    {'key': 'wireless_display_title', 'label': 'Wireless Display', 'page': const WirelessDisplayPage()},
    {'key': 'about_title', 'label': 'About', 'page': const AboutPage()},
    {'key': 'battery_saver_title', 'label': 'Battery Saver', 'page': const BatterySaverPage()},
    {'key': 'charge_title', 'label': 'Charge', 'page': const ChargePage()},
    {'key': 'device_encryption_title', 'label': 'Device Encryption', 'page': const DeviceEncryptionPage()},
  ];

  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final results = _allSettings.where((setting) {
      final label = setting['label'].toLowerCase();
      final key = setting['key'].toLowerCase();
      return label.contains(_searchQuery.toLowerCase()) ||
          key.contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('search_title', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'search_hint',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFF1F1F1F),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: results.isEmpty
                  ? const Center(
                child: Text('no_results', style: TextStyle(color: Colors.grey)),
              )
                  : ListView.builder(
                itemCount: results.length,
                itemBuilder: (context, index) { // ✅ DÜZGÜN PARAMETR
                  final setting = results[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1F1F1F),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.settings, color: Colors.cyanAccent),
                      title: Text(
                        setting['label'],
                        style: const TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => setting['page']),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}