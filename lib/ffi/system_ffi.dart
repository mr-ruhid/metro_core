// lib/ffi/system_ffi.dart

import 'dart:ffi';
import 'dart:io';
import 'dart:convert';
import 'package:ffi/ffi.dart';

class SystemFFI {
  // Real cihazda bunu false et!
  static const bool USE_MOCK = true;

  // Kitabxana yolları
  static const String _wfdLibPath = '/usr/local/lib/libwfd_manager.so';
  static const String _brightnessLibPath = '/usr/local/lib/libbrightness_manager.so';
  static const String _notifLibPath = '/usr/local/lib/libnotification_manager.so';
  static const String _phoneLibPath = '/usr/local/lib/libphone_manager.so';
  static const String _batteryLibPath = '/usr/local/lib/libbattery_manager.so';
  static const String _storageLibPath = '/usr/local/lib/libstorage_manager.so';
  static const String _aboutLibPath = '/usr/local/lib/libabout_manager.so';

  // Kitabxanaları yükləmək üçün təhlükəsiz funksiya
  static DynamicLibrary _safeLoad(String path) {
    try {
      return DynamicLibrary.open(path);
    } catch (e) {
      return DynamicLibrary.process();
    }
  }

  // ===== WIFI =====
  static Future<List<Map<String, dynamic>>> scanWifi() async {
    if (USE_MOCK) {
      await Future.delayed(Duration(seconds: 2));
      return [
        {'ssid': 'Ev WiFi', 'secured': true, 'signal': 85},
        {'ssid': 'Ofis WiFi', 'secured': true, 'signal': 70},
        {'ssid': 'Kafe WiFi', 'secured': false, 'signal': 45},
        {'ssid': 'Metro Core', 'secured': false, 'signal': 30},
      ];
    } else {
      return [];
    }
  }

  static Future<bool> connectWifi(String ssid, String password) async {
    if (USE_MOCK) {
      await Future.delayed(Duration(seconds: 1));
      return true;
    } else {
      return false;
    }
  }

  // ===== UPDATE =====
  static Future<Map<String, dynamic>> checkForUpdates() async {
    if (USE_MOCK) {
      await Future.delayed(Duration(seconds: 2));
      return {'hasUpdate': false, 'version': '1.0.0'};
    } else {
      return {'hasUpdate': false, 'version': '1.0.0'};
    }
  }

  static Future<void> downloadUpdate(Function(double) onProgress) async {
    if (USE_MOCK) {
      for (int i = 0; i <= 100; i += 5) {
        await Future.delayed(Duration(milliseconds: 100));
        onProgress(i / 100);
      }
    }
  }

  // ===== SYSTEM =====
  static bool isSystemReady() {
    return false;
  }

  static String getBattery() {
    return USE_MOCK ? _getMockBattery() : _getRealBattery();
  }

  static String _getMockBattery() {
    return "${50 + DateTime.now().second % 50}";
  }

  static String _getRealBattery() {
    return "75";
  }

  static String getNetwork() {
    return USE_MOCK ? _getMockNetwork() : _getRealNetwork();
  }

  static String _getMockNetwork() {
    final networks = ['4G', '5G', 'WiFi', 'No Signal'];
    return networks[DateTime.now().second % 4];
  }

  static String _getRealNetwork() {
    return "4G";
  }

  static String getTime() {
    return USE_MOCK ? _getMockTime() : _getRealTime();
  }

  static String _getMockTime() {
    final now = DateTime.now();
    return "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
  }

  static String _getRealTime() {
    return "12:00";
  }

  // ===== WIRELESS DISPLAY (WFD) =====
  static final DynamicLibrary _wfdLib = _safeLoad(_wfdLibPath);

  static String discoverDevices() {
    if (USE_MOCK) return '[]';
    try {
      final discover = _wfdLib
          .lookup<NativeFunction<Pointer<Utf8> Function()>>('discover_devices')
          .asFunction<Pointer<Utf8> Function()>();
      return discover().toDartString();
    } catch (e) {
      return '[]';
    }
  }

  static void connectToDevice(String deviceName) {
    if (USE_MOCK) return;
    try {
      final connect = _wfdLib
          .lookup<NativeFunction<Void Function(Pointer<Utf8>)>>('connect_to_device')
          .asFunction<void Function(Pointer<Utf8>)>();
      final name = deviceName.toNativeUtf8();
      connect(name);
      calloc.free(name);
    } catch (e) {
      print('Connect error: $e');
    }
  }

  static void startStream() {
    if (USE_MOCK) return;
    try {
      final start = _wfdLib
          .lookup<NativeFunction<Void Function()>>('start_stream')
          .asFunction<void Function()>();
      start();
    } catch (e) {
      print('Start stream error: $e');
    }
  }

  static void stopStream() {
    if (USE_MOCK) return;
    try {
      final stop = _wfdLib
          .lookup<NativeFunction<Void Function()>>('stop_stream')
          .asFunction<void Function()>();
      stop();
    } catch (e) {
      print('Stop stream error: $e');
    }
  }

  static bool isConnected() {
    if (USE_MOCK) return false;
    try {
      final connected = _wfdLib
          .lookup<NativeFunction<Bool Function()>>('is_connected')
          .asFunction<bool Function()>();
      return connected();
    } catch (e) {
      return false;
    }
  }

  // ===== BRIGHTNESS =====
  static final DynamicLibrary _brightnessLib = _safeLoad(_brightnessLibPath);

  static int getBrightness() {
    if (USE_MOCK) return 50;
    try {
      final get = _brightnessLib
          .lookup<NativeFunction<Int32 Function()>>('get_brightness')
          .asFunction<int Function()>();
      return get();
    } catch (e) {
      return 50;
    }
  }

  static void setBrightness(int level) {
    if (USE_MOCK) return;
    try {
      final set = _brightnessLib
          .lookup<NativeFunction<Void Function(Int32)>>('set_brightness')
          .asFunction<void Function(int)>();
      set(level);
    } catch (e) {
      print('Set brightness error: $e');
    }
  }

  // ===== NOTIFICATION =====
  static final DynamicLibrary _notifLib = _safeLoad(_notifLibPath);

  static bool getLockScreenShow() {
    if (USE_MOCK) return true;
    try {
      final get = _notifLib
          .lookup<NativeFunction<Bool Function()>>('get_lock_screen_show')
          .asFunction<bool Function()>();
      return get();
    } catch (e) {
      return true;
    }
  }

  static void setLockScreenShow(bool value) {
    if (USE_MOCK) return;
    try {
      final set = _notifLib
          .lookup<NativeFunction<Void Function(Bool)>>('set_lock_screen_show')
          .asFunction<void Function(bool)>();
      set(value);
    } catch (e) {
      print('Set lock screen error: $e');
    }
  }

  static bool getBannersShow() {
    if (USE_MOCK) return true;
    try {
      final get = _notifLib
          .lookup<NativeFunction<Bool Function()>>('get_banners_show')
          .asFunction<bool Function()>();
      return get();
    } catch (e) {
      return true;
    }
  }

  static void setBannersShow(bool value) {
    if (USE_MOCK) return;
    try {
      final set = _notifLib
          .lookup<NativeFunction<Void Function(Bool)>>('set_banners_show')
          .asFunction<void Function(bool)>();
      set(value);
    } catch (e) {
      print('Set banners error: $e');
    }
  }

  static bool getAlarmsShow() {
    if (USE_MOCK) return true;
    try {
      final get = _notifLib
          .lookup<NativeFunction<Bool Function()>>('get_alarms_show')
          .asFunction<bool Function()>();
      return get();
    } catch (e) {
      return true;
    }
  }

  static void setAlarmsShow(bool value) {
    if (USE_MOCK) return;
    try {
      final set = _notifLib
          .lookup<NativeFunction<Void Function(Bool)>>('set_alarms_show')
          .asFunction<void Function(bool)>();
      set(value);
    } catch (e) {
      print('Set alarms error: $e');
    }
  }

  static Map<String, dynamic> getAppsList() {
    if (USE_MOCK) return {};
    try {
      final get = _notifLib
          .lookup<NativeFunction<Pointer<Utf8> Function()>>('get_apps_list')
          .asFunction<Pointer<Utf8> Function()>();
      final result = get();
      final jsonStr = result.toDartString();
      return Map<String, dynamic>.from(jsonDecode(jsonStr));
    } catch (e) {
      return {};
    }
  }

  static void setAppEnabled(String appId, bool enabled) {
    if (USE_MOCK) return;
    try {
      final set = _notifLib
          .lookup<NativeFunction<Void Function(Pointer<Utf8>, Bool)>>('set_app_enabled')
          .asFunction<void Function(Pointer<Utf8>, bool)>();
      final id = appId.toNativeUtf8();
      set(id, enabled);
      calloc.free(id);
    } catch (e) {
      print('Set app error: $e');
    }
  }

  static bool getAppEnabled(String appId) {
    if (USE_MOCK) return true;
    try {
      final get = _notifLib
          .lookup<NativeFunction<Bool Function(Pointer<Utf8>)>>('get_app_enabled')
          .asFunction<bool Function(Pointer<Utf8>)>();
      final id = appId.toNativeUtf8();
      final result = get(id);
      calloc.free(id);
      return result;
    } catch (e) {
      return true;
    }
  }

  // ===== PHONE =====
  static final DynamicLibrary _phoneLib = _safeLoad(_phoneLibPath);

  static String getMyNumber() {
    if (USE_MOCK) return 'Not available';
    try {
      final get = _phoneLib
          .lookup<NativeFunction<Pointer<Utf8> Function()>>('get_my_number')
          .asFunction<Pointer<Utf8> Function()>();
      return get().toDartString();
    } catch (e) {
      return 'Not available';
    }
  }

  static String getVoicemailNumber() {
    if (USE_MOCK) return '+48790200200';
    try {
      final get = _phoneLib
          .lookup<NativeFunction<Pointer<Utf8> Function()>>('get_voicemail_number')
          .asFunction<Pointer<Utf8> Function()>();
      return get().toDartString();
    } catch (e) {
      return '+48790200200';
    }
  }

  static int getCallerIdMode() {
    if (USE_MOCK) return 0;
    try {
      final get = _phoneLib
          .lookup<NativeFunction<Int32 Function()>>('get_caller_id_mode')
          .asFunction<int Function()>();
      return get();
    } catch (e) {
      return 0;
    }
  }

  static void setCallerIdMode(int mode) {
    if (USE_MOCK) return;
    try {
      final set = _phoneLib
          .lookup<NativeFunction<Void Function(Int32)>>('set_caller_id_mode')
          .asFunction<void Function(int)>();
      set(mode);
    } catch (e) {
      print('Set caller ID error: $e');
    }
  }

  static bool getSilenceUnknown() {
    if (USE_MOCK) return false;
    try {
      final get = _phoneLib
          .lookup<NativeFunction<Bool Function()>>('get_silence_unknown')
          .asFunction<bool Function()>();
      return get();
    } catch (e) {
      return false;
    }
  }

  static void setSilenceUnknown(bool value) {
    if (USE_MOCK) return;
    try {
      final set = _phoneLib
          .lookup<NativeFunction<Void Function(Bool)>>('set_silence_unknown')
          .asFunction<void Function(bool)>();
      set(value);
    } catch (e) {
      print('Set silence unknown error: $e');
    }
  }

  static bool getAskReason() {
    if (USE_MOCK) return false;
    try {
      final get = _phoneLib
          .lookup<NativeFunction<Bool Function()>>('get_ask_reason')
          .asFunction<bool Function()>();
      return get();
    } catch (e) {
      return false;
    }
  }

  static void setAskReason(bool value) {
    if (USE_MOCK) return;
    try {
      final set = _phoneLib
          .lookup<NativeFunction<Void Function(Bool)>>('set_ask_reason')
          .asFunction<void Function(bool)>();
      set(value);
    } catch (e) {
      print('Set ask reason error: $e');
    }
  }

  // ===== BATTERY (CHARGE) =====
  static final DynamicLibrary _batteryLib = _safeLoad(_batteryLibPath);

  static int getBatteryLevel() {
    if (USE_MOCK) return 51;
    try {
      final get = _batteryLib
          .lookup<NativeFunction<Int32 Function()>>('battery_get_level')
          .asFunction<int Function()>();
      return get();
    } catch (e) {
      return 51;
    }
  }

  static int getBatteryRemaining() {
    if (USE_MOCK) return 90;
    try {
      final get = _batteryLib
          .lookup<NativeFunction<Int32 Function()>>('battery_get_remaining')
          .asFunction<int Function()>();
      return get();
    } catch (e) {
      return 90;
    }
  }

  static int getBatteryChargingTime() {
    if (USE_MOCK) return 42;
    try {
      final get = _batteryLib
          .lookup<NativeFunction<Int32 Function()>>('battery_get_charging_time')
          .asFunction<int Function()>();
      return get();
    } catch (e) {
      return 42;
    }
  }

  static bool getFastCharging() {
    if (USE_MOCK) return true;
    try {
      final get = _batteryLib
          .lookup<NativeFunction<Bool Function()>>('get_fast_charging')
          .asFunction<bool Function()>();
      return get();
    } catch (e) {
      return true;
    }
  }

  static void setFastCharging(bool value) {
    if (USE_MOCK) return;
    try {
      final set = _batteryLib
          .lookup<NativeFunction<Void Function(Bool)>>('set_fast_charging')
          .asFunction<void Function(bool)>();
      set(value);
    } catch (e) {
      print('Set fast charging error: $e');
    }
  }

  static bool getReverseCharging() {
    if (USE_MOCK) return false;
    try {
      final get = _batteryLib
          .lookup<NativeFunction<Bool Function()>>('get_reverse_charging')
          .asFunction<bool Function()>();
      return get();
    } catch (e) {
      return false;
    }
  }

  static void setReverseCharging(bool value) {
    if (USE_MOCK) return;
    try {
      final set = _batteryLib
          .lookup<NativeFunction<Void Function(Bool)>>('set_reverse_charging')
          .asFunction<void Function(bool)>();
      set(value);
    } catch (e) {
      print('Set reverse charging error: $e');
    }
  }

  static bool getAiProtection() {
    if (USE_MOCK) return true;
    try {
      final get = _batteryLib
          .lookup<NativeFunction<Bool Function()>>('get_ai_protection')
          .asFunction<bool Function()>();
      return get();
    } catch (e) {
      return true;
    }
  }

  static void setAiProtection(bool value) {
    if (USE_MOCK) return;
    try {
      final set = _batteryLib
          .lookup<NativeFunction<Void Function(Bool)>>('set_ai_protection')
          .asFunction<void Function(bool)>();
      set(value);
    } catch (e) {
      print('Set AI protection error: $e');
    }
  }

  static bool getBatteryBypass() {
    if (USE_MOCK) return false;
    try {
      final get = _batteryLib
          .lookup<NativeFunction<Bool Function()>>('get_battery_bypass')
          .asFunction<bool Function()>();
      return get();
    } catch (e) {
      return false;
    }
  }

  static void setBatteryBypass(bool value) {
    if (USE_MOCK) return;
    try {
      final set = _batteryLib
          .lookup<NativeFunction<Void Function(Bool)>>('set_battery_bypass')
          .asFunction<void Function(bool)>();
      set(value);
    } catch (e) {
      print('Set battery bypass error: $e');
    }
  }

  static bool getChargingSecurity() {
    if (USE_MOCK) return true;
    try {
      final get = _batteryLib
          .lookup<NativeFunction<Bool Function()>>('get_charging_security')
          .asFunction<bool Function()>();
      return get();
    } catch (e) {
      return true;
    }
  }

  static void setChargingSecurity(bool value) {
    if (USE_MOCK) return;
    try {
      final set = _batteryLib
          .lookup<NativeFunction<Void Function(Bool)>>('set_charging_security')
          .asFunction<void Function(bool)>();
      set(value);
    } catch (e) {
      print('Set charging security error: $e');
    }
  }

  static bool isReverseChargingSupported() {
    if (USE_MOCK) return false;
    try {
      final get = _batteryLib
          .lookup<NativeFunction<Bool Function()>>('is_reverse_charging_supported')
          .asFunction<bool Function()>();
      return get();
    } catch (e) {
      return false;
    }
  }

  static bool isBatteryBypassSupported() {
    if (USE_MOCK) return false;
    try {
      final get = _batteryLib
          .lookup<NativeFunction<Bool Function()>>('is_battery_bypass_supported')
          .asFunction<bool Function()>();
      return get();
    } catch (e) {
      return false;
    }
  }

  // ===== STORAGE =====
  static final DynamicLibrary _storageLib = _safeLoad(_storageLibPath);

  static double getTotalStorage() {
    if (USE_MOCK) return 32.0;
    try {
      final get = _storageLib
          .lookup<NativeFunction<Double Function()>>('get_total_storage')
          .asFunction<double Function()>();
      return get();
    } catch (e) {
      return 32.0;
    }
  }

  static double getUsedStorage() {
    if (USE_MOCK) return 9.16;
    try {
      final get = _storageLib
          .lookup<NativeFunction<Double Function()>>('get_used_storage')
          .asFunction<double Function()>();
      return get();
    } catch (e) {
      return 9.16;
    }
  }

  static double getFreeStorage() {
    if (USE_MOCK) return 22.84;
    try {
      final get = _storageLib
          .lookup<NativeFunction<Double Function()>>('get_free_storage')
          .asFunction<double Function()>();
      return get();
    } catch (e) {
      return 22.84;
    }
  }

  static bool getLowStorageWarning() {
    if (USE_MOCK) return true;
    try {
      final get = _storageLib
          .lookup<NativeFunction<Bool Function()>>('get_low_storage_warning')
          .asFunction<bool Function()>();
      return get();
    } catch (e) {
      return true;
    }
  }

  static void setLowStorageWarning(bool value) {
    if (USE_MOCK) return;
    try {
      final set = _storageLib
          .lookup<NativeFunction<Void Function(Bool)>>('set_low_storage_warning')
          .asFunction<void Function(bool)>();
      set(value);
    } catch (e) {
      print('Set low storage warning error: $e');
    }
  }

  // ===== ABOUT (SİSTEM MƏLUMATLARI) =====
  static final DynamicLibrary _aboutLib = _safeLoad(_aboutLibPath);

  static String getKernelVersion() {
    if (USE_MOCK) return '6.5.0-metro';
    try {
      final get = _aboutLib
          .lookup<NativeFunction<Pointer<Utf8> Function()>>('get_kernel_version')
          .asFunction<Pointer<Utf8> Function()>();
      return get().toDartString();
    } catch (e) {
      return '6.5.0-metro';
    }
  }

  static String getCpuModel() {
    if (USE_MOCK) return 'Metro Core X1 @ 2.4GHz';
    try {
      final get = _aboutLib
          .lookup<NativeFunction<Pointer<Utf8> Function()>>('get_cpu_model')
          .asFunction<Pointer<Utf8> Function()>();
      return get().toDartString();
    } catch (e) {
      return 'Metro Core X1 @ 2.4GHz';
    }
  }

  static double getRamTotal() {
    if (USE_MOCK) return 16.0;
    try {
      final get = _aboutLib
          .lookup<NativeFunction<Double Function()>>('get_ram_total')
          .asFunction<double Function()>();
      return get();
    } catch (e) {
      return 16.0;
    }
  }
}