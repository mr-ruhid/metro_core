import 'package:flutter/material.dart';
import 'dart:convert';

class DataUsageService extends ChangeNotifier {
  static final DataUsageService _instance = DataUsageService._internal();
  factory DataUsageService() => _instance;
  DataUsageService._internal();

  // State
  DataUsage _cellularData = DataUsage.empty();
  DataUsage _wifiData = DataUsage.empty();
  DataUsage _totalData = DataUsage.empty();
  List<AppDataUsage> _appDataUsage = [];
  double _dataLimit = 10.0; // GB
  String _limitPeriod = 'month';

  // Getters
  DataUsage get cellularData => _cellularData;
  DataUsage get wifiData => _wifiData;
  DataUsage get totalData => _totalData;
  List<AppDataUsage> get appDataUsage => _appDataUsage;
  double get dataLimit => _dataLimit;
  String get limitPeriod => _limitPeriod;

  void init() {
    _loadData();
  }

  void _loadData() {
    // Simulated data - real implementation from FFI
    _cellularData = DataUsage(
      today: 0.45,
      week: 2.8,
      month: 8.5,
      total: 8.5,
    );

    _wifiData = DataUsage(
      today: 1.2,
      week: 8.5,
      month: 45.0,
      total: 45.0,
    );

    _totalData = DataUsage(
      today: _cellularData.today + _wifiData.today,
      week: _cellularData.week + _wifiData.week,
      month: _cellularData.month + _wifiData.month,
      total: _cellularData.total + _wifiData.total,
    );

    _appDataUsage = [
      AppDataUsage(name: 'YouTube', dataUsed: 2.5, icon: Icons.play_circle, color: Colors.red),
      AppDataUsage(name: 'Spotify', dataUsed: 1.8, icon: Icons.music_note, color: Colors.green),
      AppDataUsage(name: 'Chrome', dataUsed: 1.2, icon: Icons.web, color: Colors.blue),
      AppDataUsage(name: 'Instagram', dataUsed: 0.8, icon: Icons.camera_alt, color: Colors.purple),
      AppDataUsage(name: 'WhatsApp', dataUsed: 0.5, icon: Icons.chat, color: Colors.green),
      AppDataUsage(name: 'Maps', dataUsed: 0.3, icon: Icons.map, color: Colors.cyan),
    ];

    notifyListeners();
  }

  void refreshData() {
    _loadData();
  }

  void setDataLimit(double limit, String period) {
    _dataLimit = limit;
    _limitPeriod = period;
    notifyListeners();
  }

  void resetStatistics() {
    _loadData();
    notifyListeners();
  }
}

class DataUsage {
  final double today;
  final double week;
  final double month;
  final double total;

  const DataUsage({
    required this.today,
    required this.week,
    required this.month,
    required this.total,
  });

  factory DataUsage.empty() {
    return const DataUsage(
      today: 0,
      week: 0,
      month: 0,
      total: 0,
    );
  }
}

class AppDataUsage {
  final String name;
  final double dataUsed;
  final IconData icon;
  final Color color;

  AppDataUsage({
    required this.name,
    required this.dataUsed,
    required this.icon,
    required this.color,
  });
}
