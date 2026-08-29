import 'package:flutter/material.dart';
import 'package:metro_core/ffi/wifi_ffi.dart';
import 'dart:convert';

class WifiService extends ChangeNotifier {
  static final WifiService _instance = WifiService._internal();
  factory WifiService() => _instance;
  WifiService._internal();

  final WifiFFI _ffi = WifiFFI();

  bool _isWifiEnabled = false;
  List<WifiNetwork> _networks = [];
  List<String> _savedNetworks = [];
  String _currentNetwork = 'None';
  int _signalStrength = 0;

  bool get isWifiEnabled => _isWifiEnabled;
  List<WifiNetwork> get networks => _networks;
  List<String> get savedNetworks => _savedNetworks;
  String get currentNetwork => _currentNetwork;
  int get signalStrength => _signalStrength;

  void init() {
    _ffi.loadLibrary();
    _loadData();
  }

  void _loadData() {
    _isWifiEnabled = _ffi.isWifiEnabled();
    _currentNetwork = _ffi.getCurrentNetwork();
    _signalStrength = _ffi.getSignalStrength();

    // Load saved networks
    final savedJson = _ffi.getSavedNetworks();
    try {
      _savedNetworks = (jsonDecode(savedJson) as List).cast<String>();
    } catch (e) {
      _savedNetworks = [];
    }

    notifyListeners();
  }

  void toggleWifi() {
    final newState = !_isWifiEnabled;
    _ffi.setWifiEnabled(newState);
    _isWifiEnabled = newState;
    if (newState) {
      scanNetworks();
    } else {
      _networks.clear();
      notifyListeners();
    }
  }

  Future<void> scanNetworks() async {
    if (!_isWifiEnabled) return;

    final json = _ffi.scanNetworks();
    try {
      final List<dynamic> data = jsonDecode(json);
      _networks = data.map((item) {
        return WifiNetwork(
          ssid: item['ssid'] ?? 'Unknown',
          signal: item['signal'] ?? 0,
          security: item['security'] ?? 'Open',
        );
      }).toList();
      _networks.sort((a, b) => b.signal.compareTo(a.signal));

      // Update current network info
      _currentNetwork = _ffi.getCurrentNetwork();
      _signalStrength = _ffi.getSignalStrength();

      notifyListeners();
    } catch (e) {
      print('Error parsing networks: $e');
    }
  }

  // ✅ BÜTÜN METODLARA context əlavə edildi
  void connectToNetwork(String ssid, String password, BuildContext context) {
    final success = _ffi.connectToNetwork(ssid, password);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Connected to $ssid'),
          backgroundColor: Colors.green,
        ),
      );
      scanNetworks();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ Failed to connect'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void disconnectNetwork(BuildContext context) {
    final success = _ffi.disconnectNetwork();
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Disconnected'),
          backgroundColor: Colors.orange,
        ),
      );
      scanNetworks();
    }
  }

  void forgetNetwork(String ssid, BuildContext context) {
    final success = _ffi.forgetNetwork(ssid);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('🗑️ Forgotten: $ssid'),
          backgroundColor: Colors.orange,
        ),
      );
      scanNetworks();
    }
  }
}

class WifiNetwork {
  final String ssid;
  final int signal;
  final String security;

  WifiNetwork({
    required this.ssid,
    required this.signal,
    required this.security,
  });
}