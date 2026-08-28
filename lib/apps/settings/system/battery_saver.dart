// lib/apps/settings/system/battery_saver.dart

import 'package:flutter/material.dart';
import '../../../ffi/system_ffi.dart';
import 'package:fl_chart/fl_chart.dart'; // Qrafik üçün

class BatterySaverPage extends StatefulWidget {
  const BatterySaverPage({super.key});

  @override
  State<BatterySaverPage> createState() => _BatterySaverPageState();
}

class _BatterySaverPageState extends State<BatterySaverPage> {
  int _batteryLevel = 0;
  int _remaining = 0;
  int _chargingTime = 0;
  String _powerMode = 'Balans';
  bool _isLoading = true;

  final List<String> _powerModes = [
    'Yüksək performans',
    'Balans',
    'Pil qənaəti',
    'Ultra güc qənaəti'
  ];

  // Saatlıq batareya səviyyələri (nümunə)
  final List<double> _batteryHistory = [100, 95, 88, 82, 75, 68, 60, 51];
  final List<String> _hours = ['00:00', '04:00', '08:00', '12:00', '16:00', '20:00'];

  // Tətbiq güc istifadəsi (nümunə)
  final List<Map<String, dynamic>> _appUsage = [
    {'name': 'Ekran', 'percent': 15, 'icon': Icons.screen_rotation},
    {'name': 'Wi-Fi', 'percent': 8, 'icon': Icons.wifi},
    {'name': 'Oyun', 'percent': 6, 'icon': Icons.sports_esports},
    {'name': 'Kamera', 'percent': 4, 'icon': Icons.photo_camera},
    {'name': 'Telefon', 'percent': 2, 'icon': Icons.phone},
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _batteryLevel = SystemFFI.getBatteryLevel();
      _remaining = SystemFFI.getBatteryRemaining();
      _chargingTime = SystemFFI.getBatteryChargingTime();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('battery_saver_text'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        color: Colors.black,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // === Battery status ===
            _buildBatteryStatus(),

            const SizedBox(height: 24),

            // === Power mode ===
            _buildPowerMode(),

            const SizedBox(height: 24),

            // === Battery usage graph ===
            _buildBatteryGraph(),

            const SizedBox(height: 24),

            // === App power usage ===
            _buildAppUsage(),
          ],
        ),
      ),
    );
  }

  Widget _buildBatteryStatus() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.battery_std,
                color: _batteryLevel > 20 ? Colors.green : Colors.red,
                size: 40,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$_batteryLevel%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: _batteryLevel / 100,
                      backgroundColor: Colors.grey[800],
                      color: _batteryLevel > 20 ? Colors.green : Colors.red,
                      minHeight: 8,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.timer, color: Colors.grey, size: 20),
              const SizedBox(width: 8),
              Text(
                'remaining_time_text $_remaining min',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.flash_on, color: Colors.green, size: 20),
              const SizedBox(width: 8),
              Text(
                'charging_time_text $_chargingTime min',
                style: const TextStyle(color: Colors.green),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPowerMode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'power_mode_text',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ListTile(
          leading: const Icon(Icons.power_settings_new, color: Colors.deepPurple),
          title: Text(
            _powerMode,
            style: const TextStyle(color: Colors.white),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
          onTap: _showPowerModeDialog,
        ),
      ],
    );
  }

  Widget _buildBatteryGraph() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'battery_usage_graph_text',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 150,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= 0 && value.toInt() < _hours.length) {
                          return Text(
                            _hours[value.toInt()],
                            style: const TextStyle(color: Colors.grey, fontSize: 10),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: _batteryHistory.asMap().entries.map((e) {
                      return FlSpot(e.key.toDouble(), e.value);
                    }).toList(),
                    isCurved: true,
                    color: Colors.deepPurple,
                    barWidth: 3,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.deepPurple.withOpacity(0.2),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppUsage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'app_power_usage_text',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ..._appUsage.map((app) {
          return _buildAppUsageTile(
            icon: app['icon'] as IconData,
            name: app['name'] as String,
            percent: app['percent'] as int,
          );
        }).toList(),
      ],
    );
  }

  Widget _buildAppUsageTile({
    required IconData icon,
    required String name,
    required int percent,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepPurple),
      title: Text(
        name,
        style: const TextStyle(color: Colors.white),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$percent%',
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 60,
            child: LinearProgressIndicator(
              value: percent / 100,
              backgroundColor: Colors.grey[800],
              color: Colors.deepPurple,
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  void _showPowerModeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'select_power_mode_text',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _powerModes.map((mode) {
            return RadioListTile<String>(
              title: Text(mode, style: const TextStyle(color: Colors.white)),
              value: mode,
              groupValue: _powerMode,
              activeColor: Colors.deepPurple,
              onChanged: (value) {
                setState(() => _powerMode = value!);
                // TODO: C++ ilə güc rejimini dəyiş
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}