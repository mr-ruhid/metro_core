// lib/ffi/cellular_ffi.dart
import 'dart:ffi';
import 'dart:typed_data';
import 'package:ffi/ffi.dart';

class CellularFFI {
  static final CellularFFI _instance = CellularFFI._internal();
  factory CellularFFI() => _instance;
  CellularFFI._internal();

  late final DynamicLibrary _lib;

  bool _isLoaded = false;

  void loadLibrary() {
    try {
      _lib = DynamicLibrary.open('libcellular_manager.so');
      _isLoaded = true;
      print('✅ Cellular library loaded');
    } catch (e) {
      print('⚠️ Cellular library not found: $e');
      _isLoaded = false;
    }
  }

  // Get SIM status
  String getSimStatus() {
    if (!_isLoaded) return '{"has_sim": false, "error": "Library not loaded"}';
    try {
      final getSimStatus = _lib.lookup<NativeFunction<Pointer<Utf8> Function()>>('get_sim_status');
      final result = getSimStatus.asFunction<Pointer<Utf8> Function()>();
      return result().toDartString();
    } catch (e) {
      return '{"has_sim": false, "error": "$e"}';
    }
  }

  // Get network type
  String getNetworkType() {
    if (!_isLoaded) return 'Unknown';
    try {
      final getNetworkType = _lib.lookup<NativeFunction<Pointer<Utf8> Function()>>('get_network_type');
      final result = getNetworkType.asFunction<Pointer<Utf8> Function()>();
      return result().toDartString();
    } catch (e) {
      return 'Unknown';
    }
  }

  // Set mobile data
  bool setMobileData(bool enabled) {
    if (!_isLoaded) return false;
    try {
      final setMobileData = _lib.lookup<NativeFunction<Bool Function(Bool)>>('set_mobile_data');
      final result = setMobileData.asFunction<bool Function(bool)>();
      return result(enabled);
    } catch (e) {
      return false;
    }
  }

  // Get data usage
  String getDataUsage() {
    if (!_isLoaded) return '{"used": 0, "total": 0, "unit": "GB"}';
    try {
      final getDataUsage = _lib.lookup<NativeFunction<Pointer<Utf8> Function()>>('get_data_usage');
      final result = getDataUsage.asFunction<Pointer<Utf8> Function()>();
      return result().toDartString();
    } catch (e) {
      return '{"used": 0, "total": 0, "unit": "GB"}';
    }
  }

  // Get network operators
  List<String> getNetworkOperators() {
    if (!_isLoaded) return [];
    try {
      final getOperators = _lib.lookup<NativeFunction<Pointer<Utf8> Function()>>('get_network_operators');
      final result = getOperators.asFunction<Pointer<Utf8> Function()>();
      final json = result().toDartString();
      // Parse JSON array
      return json.replaceAll('[', '').replaceAll(']', '').replaceAll('"', '').split(',');
    } catch (e) {
      return [];
    }
  }

  // Set preferred network type
  bool setPreferredNetwork(String type) {
    if (!_isLoaded) return false;
    try {
      final setNetwork = _lib.lookup<NativeFunction<Bool Function(Pointer<Utf8>)>>('set_preferred_network');
      final result = setNetwork.asFunction<bool Function(Pointer<Utf8>)>();
      final typePtr = type.toNativeUtf8();
      return result(typePtr);
    } catch (e) {
      return false;
    }
  }
}