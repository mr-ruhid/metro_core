import 'package:flutter/material.dart';

class AirplaneModeService extends ChangeNotifier {
  static final AirplaneModeService _instance = AirplaneModeService._internal();
  factory AirplaneModeService() => _instance;
  AirplaneModeService._internal();

  // State
  bool _isAirplaneMode = false;
  bool _isWifiEnabled = true;
  bool _isBluetoothEnabled = true;
  bool _isCellularEnabled = true;
  bool _isHotspotEnabled = false;

  // Previous states for restore
  bool _previousWifiState = true;
  bool _previousBluetoothState = true;
  bool _previousCellularState = true;
  bool _previousHotspotState = false;

  // Getters
  bool get isAirplaneMode => _isAirplaneMode;
  bool get isWifiEnabled => _isWifiEnabled;
  bool get isBluetoothEnabled => _isBluetoothEnabled;
  bool get isCellularEnabled => _isCellularEnabled;
  bool get isHotspotEnabled => _isHotspotEnabled;

  void init() {
    // Load saved states
    _loadStates();
  }

  void _loadStates() {
    // Real implementation: Load from shared preferences
    // For now, use default values
    _isAirplaneMode = false;
    _isWifiEnabled = true;
    _isBluetoothEnabled = true;
    _isCellularEnabled = true;
    _isHotspotEnabled = false;
    notifyListeners();
  }

  void toggleAirplaneMode() {
    _isAirplaneMode = !_isAirplaneMode;

    if (_isAirplaneMode) {
      // Save current states before turning off
      _previousWifiState = _isWifiEnabled;
      _previousBluetoothState = _isBluetoothEnabled;
      _previousCellularState = _isCellularEnabled;
      _previousHotspotState = _isHotspotEnabled;

      // Turn off all connections
      _isWifiEnabled = false;
      _isBluetoothEnabled = false;
      _isCellularEnabled = false;
      _isHotspotEnabled = false;

      // Real implementation: Call native methods
      _disableAllConnections();
    } else {
      // Restore previous states
      _isWifiEnabled = _previousWifiState;
      _isBluetoothEnabled = _previousBluetoothState;
      _isCellularEnabled = _previousCellularState;
      _isHotspotEnabled = _previousHotspotState;

      // Real implementation: Restore connections
      _restoreAllConnections();
    }

    notifyListeners();
  }

  // Individual toggles (can be used even in airplane mode)
  void toggleWifi() {
    _isWifiEnabled = !_isWifiEnabled;
    // Real implementation: Call native method
    notifyListeners();
  }

  void toggleBluetooth() {
    _isBluetoothEnabled = !_isBluetoothEnabled;
    // Real implementation: Call native method
    notifyListeners();
  }

  void toggleCellular() {
    _isCellularEnabled = !_isCellularEnabled;
    // Real implementation: Call native method
    notifyListeners();
  }

  void toggleHotspot() {
    _isHotspotEnabled = !_isHotspotEnabled;
    // Real implementation: Call native method
    notifyListeners();
  }

  // Reset all connections
  void resetAll() {
    _isAirplaneMode = false;
    _isWifiEnabled = true;
    _isBluetoothEnabled = true;
    _isCellularEnabled = true;
    _isHotspotEnabled = false;

    _previousWifiState = true;
    _previousBluetoothState = true;
    _previousCellularState = true;
    _previousHotspotState = false;

    // Real implementation: Reset all
    notifyListeners();
  }

  // Private methods for real implementation
  void _disableAllConnections() {
    // Call native methods to disable:
    // - Wi-Fi: set_wifi_enabled(false)
    // - Bluetooth: set_bluetooth_enabled(false)
    // - Cellular: set_mobile_data(false)
    // - Hotspot: disable_hotspot()
  }

  void _restoreAllConnections() {
    // Call native methods to restore:
    // - Wi-Fi: set_wifi_enabled(_previousWifiState)
    // - Bluetooth: set_bluetooth_enabled(_previousBluetoothState)
    // - Cellular: set_mobile_data(_previousCellularState)
    // - Hotspot: enable_hotspot if was enabled
  }
}