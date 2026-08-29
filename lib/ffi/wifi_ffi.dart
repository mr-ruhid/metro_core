import 'dart:ffi';
import 'package:ffi/ffi.dart';

class WifiFFI {
  static final WifiFFI _instance = WifiFFI._internal();
  factory WifiFFI() => _instance;
  WifiFFI._internal();

  late final DynamicLibrary _lib;
  bool _isLoaded = false;

  void loadLibrary() {
    try {
      _lib = DynamicLibrary.open('libwifi_manager.so');
      _isLoaded = true;
      print('✅ Wi-Fi library loaded');
    } catch (e) {
      print('⚠️ Wi-Fi library not found: $e');
      _isLoaded = false;
    }
  }

  bool setWifiEnabled(bool enabled) {
    if (!_isLoaded) return false;
    try {
      final func = _lib.lookup<NativeFunction<Bool Function(Bool)>>('set_wifi_enabled');
      final result = func.asFunction<bool Function(bool)>();
      return result(enabled);
    } catch (e) {
      return false;
    }
  }

  bool isWifiEnabled() {
    if (!_isLoaded) return false;
    try {
      final func = _lib.lookup<NativeFunction<Bool Function()>>('is_wifi_enabled');
      final result = func.asFunction<bool Function()>();
      return result();
    } catch (e) {
      return false;
    }
  }

  String scanNetworks() {
    if (!_isLoaded) return '[]';
    try {
      final func = _lib.lookup<NativeFunction<Pointer<Utf8> Function()>>('scan_networks');
      final result = func.asFunction<Pointer<Utf8> Function()>();
      return result().toDartString();
    } catch (e) {
      return '[]';
    }
  }

  bool connectToNetwork(String ssid, String password) {
    if (!_isLoaded) return false;
    try {
      final func = _lib.lookup<NativeFunction<Bool Function(Pointer<Utf8>, Pointer<Utf8>)>>('connect_to_network');
      final result = func.asFunction<bool Function(Pointer<Utf8>, Pointer<Utf8>)>();
      return result(ssid.toNativeUtf8(), password.toNativeUtf8());
    } catch (e) {
      return false;
    }
  }

  bool disconnectNetwork() {
    if (!_isLoaded) return false;
    try {
      final func = _lib.lookup<NativeFunction<Bool Function()>>('disconnect_network');
      final result = func.asFunction<bool Function()>();
      return result();
    } catch (e) {
      return false;
    }
  }

  String getCurrentNetwork() {
    if (!_isLoaded) return 'None';
    try {
      final func = _lib.lookup<NativeFunction<Pointer<Utf8> Function()>>('get_current_network');
      final result = func.asFunction<Pointer<Utf8> Function()>();
      return result().toDartString();
    } catch (e) {
      return 'None';
    }
  }

  int getSignalStrength() {
    if (!_isLoaded) return 0;
    try {
      final func = _lib.lookup<NativeFunction<Int32 Function()>>('get_signal_strength');
      final result = func.asFunction<int Function()>();
      return result();
    } catch (e) {
      return 0;
    }
  }

  String getSavedNetworks() {
    if (!_isLoaded) return '[]';
    try {
      final func = _lib.lookup<NativeFunction<Pointer<Utf8> Function()>>('get_saved_networks');
      final result = func.asFunction<Pointer<Utf8> Function()>();
      return result().toDartString();
    } catch (e) {
      return '[]';
    }
  }

  bool forgetNetwork(String ssid) {
    if (!_isLoaded) return false;
    try {
      final func = _lib.lookup<NativeFunction<Bool Function(Pointer<Utf8>)>>('forget_network');
      final result = func.asFunction<bool Function(Pointer<Utf8>)>();
      return result(ssid.toNativeUtf8());
    } catch (e) {
      return false;
    }
  }
}