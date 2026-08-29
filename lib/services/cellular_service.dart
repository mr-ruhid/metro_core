// lib/services/cellular_service.dart
import 'package:flutter/material.dart';
import 'package:metro_core/ffi/cellular_ffi.dart';
import 'dart:convert';

class CellularService extends ChangeNotifier {
  static final CellularService _instance = CellularService._internal();
  factory CellularService() => _instance;
  CellularService._internal();

  final CellularFFI _ffi = CellularFFI();

  // State
  bool _isMobileDataEnabled = true;
  bool _isRoamingEnabled = false;
  String _selectedNetworkType = '5G';
  String _selectedOperator = 'Auto';
  String _simStatus = 'Loading...';
  String _phoneNumber = 'Unknown';
  String _imei = 'Unknown';
  String _networkType = 'Unknown';
  String _operatorName = 'Unknown';
  double _dataUsed = 0;
  double _dataTotal = 10;
  List<String> _availableOperators = [];

  // Getters
  bool get isMobileDataEnabled => _isMobileDataEnabled;
  bool get isRoamingEnabled => _isRoamingEnabled;
  String get selectedNetworkType => _selectedNetworkType;
  String get selectedOperator => _selectedOperator;
  String get simStatus => _simStatus;
  String get phoneNumber => _phoneNumber;
  String get imei => _imei;
  String get networkType => _networkType;
  String get operatorName => _operatorName;
  double get dataUsed => _dataUsed;
  double get dataTotal => _dataTotal;
  double get dataRemaining => _dataTotal - _dataUsed;
  double get dataUsagePercent => _dataTotal > 0 ? (_dataUsed / _dataTotal) * 100 : 0;
  List<String> get availableOperators => _availableOperators;

  final List<String> networkTypes = ['2G', '3G', '4G', '5G'];

  void init() {
    _ffi.loadLibrary();
    _loadData();
  }

  void _loadData() {
    try {
      // Get SIM status
      final simJson = _ffi.getSimStatus();
      final simData = jsonDecode(simJson);
      _simStatus = simData['has_sim'] ? '✅ SIM detected' : '❌ No SIM';
      _phoneNumber = simData['number'] ?? 'Unknown';
      _imei = simData['imei'] ?? 'Unknown';
      _operatorName = simData['operator'] ?? 'Unknown';

      // Get network type
      _networkType = _ffi.getNetworkType();

      // Get data usage
      final dataJson = _ffi.getDataUsage();
      final dataData = jsonDecode(dataJson);
      _dataUsed = (dataData['used'] ?? 0).toDouble();
      _dataTotal = (dataData['total'] ?? 10).toDouble();

      // Get operators
      _availableOperators = _ffi.getNetworkOperators();

      notifyListeners();
    } catch (e) {
      print('Error loading cellular data: $e');
      _simStatus = '⚠️ Error loading';
    }
  }

  void toggleMobileData() {
    _isMobileDataEnabled = !_isMobileDataEnabled;
    _ffi.setMobileData(_isMobileDataEnabled);
    notifyListeners();
  }

  void toggleRoaming() {
    _isRoamingEnabled = !_isRoamingEnabled;
    notifyListeners();
  }

  void setNetworkType(String type) {
    if (networkTypes.contains(type)) {
      _selectedNetworkType = type;
      _ffi.setPreferredNetwork(type);
      notifyListeners();
    }
  }

  void setOperator(String operator) {
    _selectedOperator = operator;
    notifyListeners();
  }

  // ✅ Context ilə refresh
  void refreshData(BuildContext context) {
    _loadData();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('🔄 Refreshing network data...')),
    );
  }

  // Context olmadan refresh (snackbar olmadan)
  void refreshDataSilent() {
    _loadData();
  }

  void resetNetworkSettings() {
    // Reset all settings
    _isMobileDataEnabled = true;
    _isRoamingEnabled = false;
    _selectedNetworkType = '5G';
    _selectedOperator = 'Auto';
    notifyListeners();
  }

  // ========== SNACKBAR METODLARI ==========

  // Ümumi snackbar metodu
  void showSnackBar(BuildContext context, String message, {Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color ?? Colors.blue,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ✅ Success snackbar
  void showSuccess(BuildContext context, String message) {
    showSnackBar(context, message, color: Colors.green);
  }

  // ✅ Error snackbar
  void showError(BuildContext context, String message) {
    showSnackBar(context, message, color: Colors.red);
  }

  // ✅ Info snackbar
  void showInfo(BuildContext context, String message) {
    showSnackBar(context, message, color: Colors.blue);
  }

  // ✅ Warning snackbar
  void showWarning(BuildContext context, String message) {
    showSnackBar(context, message, color: Colors.orange);
  }
}