// lib/ffi/system_ffi.dart

class SystemFFI {
  static const bool USE_MOCK = true;

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
      // TODO: REAL C++ FFI
      return [];
    }
  }

  static Future<bool> connectWifi(String ssid, String password) async {
    if (USE_MOCK) {
      await Future.delayed(Duration(seconds: 1));
      return true;
    } else {
      // TODO: REAL C++ FFI
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
}