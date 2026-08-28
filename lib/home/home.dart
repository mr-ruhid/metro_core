// lib/screens/home.dart

import 'package:flutter/material.dart';
import '../ffi/system_ffi.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _time = '--:--';
  String _battery = '--';
  String _network = '--';

  @override
  void initState() {
    super.initState();
    _updateData();
  }

  void _updateData() {
    setState(() {
      _time = SystemFFI.getTime();
      _battery = SystemFFI.getBattery();
      _network = SystemFFI.getNetwork();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Column(
          children: [
            // Status Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _time,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        _network == 'WiFi' ? Icons.wifi : Icons.signal_cellular_alt,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.battery_std,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$_battery%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Live Tiles Grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: GridView.count(
                  crossAxisCount: 4,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.2,
                  children: [
                    _buildTile(
                      icon: Icons.access_time,
                      title: 'Saat',
                      value: _time,
                      color: Colors.deepPurple,
                    ),
                    _buildTile(
                      icon: Icons.battery_std,
                      title: 'Batareya',
                      value: '$_battery%',
                      color: Colors.green,
                    ),
                    _buildTile(
                      icon: Icons.wifi,
                      title: 'Şəbəkə',
                      value: _network,
                      color: Colors.blue,
                    ),
                    _buildTile(
                      icon: Icons.calendar_today,
                      title: 'Tarix',
                      value: '${DateTime.now().day}/${DateTime.now().month}',
                      color: Colors.orange,
                    ),
                    _buildTile(
                      icon: Icons.settings,
                      title: 'Ayarlar',
                      value: '',
                      color: Colors.grey,
                    ),
                    _buildTile(
                      icon: Icons.phone_android,
                      title: 'Sistem',
                      value: 'metro_core',
                      color: Colors.purple,
                    ),
                    _buildTile(
                      icon: Icons.update,
                      title: 'Yeniləmə',
                      value: 'Yoxla',
                      color: Colors.teal,
                    ),
                    _buildTile(
                      icon: Icons.info,
                      title: 'Haqqında',
                      value: 'v1.0.0',
                      color: Colors.indigo,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTile({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () {
        // Tile tıklanma əməliyyatları
      },
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.5),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 32,
              ),
              const SizedBox(height: 8),
              Text(
                value.isNotEmpty ? value : title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (value.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}