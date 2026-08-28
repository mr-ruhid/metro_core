// lib/services/device_encryption_service.dart
import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';

// C++ funksiyalarının imzaları (REAL olmalıdır)
typedef _NativeStatusFunc = Int32 Function();
typedef _NativeEnableFunc = Int32 Function(Pointer<Utf8> pin);
typedef _NativeDisableFunc = Int32 Function(Pointer<Utf8> pin);

class DeviceEncryptionService {
  DeviceEncryptionService._internal();
  static final DeviceEncryptionService _instance = DeviceEncryptionService._internal();
  factory DeviceEncryptionService() => _instance;

  // REAL cihazda kitabxana burada olacaq
  static const String _libPath = '/usr/lib/metro_core/libsecurity.so';

  // Real cihazda istifadə etmək üçün bunu FALSE et!
  static const bool USE_MOCK = false;

  static final DynamicLibrary _lib = _loadLibrary();

  // Funksiya nöqtələri
  static final _nativeGetStatus = _lib.lookupFunction<_NativeStatusFunc, int Function()>('get_encryption_status');
  static final _nativeEnable = _lib.lookupFunction<_NativeEnableFunc, int Function(Pointer<Utf8>)>('enable_encryption');
  static final _nativeDisable = _lib.lookupFunction<_NativeDisableFunc, int Function(Pointer<Utf8>)>('disable_encryption');

  static DynamicLibrary _loadLibrary() {
    try {
      return DynamicLibrary.open(_libPath);
    } catch (e) {
      // Real cihazda kitabxana tapılmayanda çökməmək üçün
      return DynamicLibrary.process();
    }
  }

  // 1. Statusu yoxlamaq
  Future<bool> checkEncryptionStatus() async {
    if (USE_MOCK) {
      await Future.delayed(const Duration(milliseconds: 500));
      return false;
    }
    try {
      final result = _nativeGetStatus();
      return result == 1;
    } catch (e) {
      return false;
    }
  }

  // 2. Şifrələməni aktivləşdirmək
  Future<String> enableEncryption(String pin) async {
    if (USE_MOCK) {
      await Future.delayed(const Duration(milliseconds: 800));
      if (pin.length < 4) return 'PIN ən azı 4 rəqəm olmalıdır';
      return 'Uğurlu';
    }
    try {
      final nativePin = pin.toNativeUtf8();
      try {
        final result = _nativeEnable(nativePin);
        if (result == 1) return 'Uğurlu';
        if (result == -1) return 'PIN ən azı 4 rəqəm olmalıdır';
        return 'Şifrələmə başladıla bilmədi (xəta kodu: $result)';
      } finally {
        malloc.free(nativePin);
      }
    } catch (e) {
      return 'Xəta: $e';
    }
  }

  // 3. Şifrələməni söndürmək
  Future<String> disableEncryption(String pin) async {
    if (USE_MOCK) {
      await Future.delayed(const Duration(milliseconds: 800));
      return 'Uğurlu';
    }
    try {
      final nativePin = pin.toNativeUtf8();
      try {
        final result = _nativeDisable(nativePin);
        if (result == 1) return 'Uğurlu';
        return 'Şifrələmə söndürülə bilmədi (xəta kodu: $result)';
      } finally {
        malloc.free(nativePin);
      }
    } catch (e) {
      return 'Xəta: $e';
    }
  }
}