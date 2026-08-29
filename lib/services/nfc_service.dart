import 'package:flutter/material.dart';

class NfcService extends ChangeNotifier {
  static final NfcService _instance = NfcService._internal();
  factory NfcService() => _instance;
  NfcService._internal();

  // NFC Settings
  bool _isNfcEnabled = true;
  bool _isNfcSoundEnabled = true;
  bool _isNfcVibrationEnabled = true;
  bool _isAndroidBeamEnabled = true;
  bool _isHostCardEmulationEnabled = false;

  // NFC Status
  String _lastScannedTag = 'None';
  String _lastTagData = '';
  String _lastTagType = '';
  List<NfcTag> _tagHistory = [];
  bool _isScanning = false;

  // Getters
  bool get isNfcEnabled => _isNfcEnabled;
  bool get isNfcSoundEnabled => _isNfcSoundEnabled;
  bool get isNfcVibrationEnabled => _isNfcVibrationEnabled;
  bool get isAndroidBeamEnabled => _isAndroidBeamEnabled;
  bool get isHostCardEmulationEnabled => _isHostCardEmulationEnabled;
  String get lastScannedTag => _lastScannedTag;
  String get lastTagData => _lastTagData;
  String get lastTagType => _lastTagType;
  List<NfcTag> get tagHistory => _tagHistory;
  bool get isScanning => _isScanning;

  // Toggle Methods
  void toggleNfc() {
    _isNfcEnabled = !_isNfcEnabled;
    if (!_isNfcEnabled) {
      _lastScannedTag = 'None';
      _lastTagData = '';
      _lastTagType = '';
      _isScanning = false;
    }
    notifyListeners();
    debugPrint('📡 NFC toggled: ${_isNfcEnabled ? "ON" : "OFF"}');
  }

  void toggleSound() {
    _isNfcSoundEnabled = !_isNfcSoundEnabled;
    notifyListeners();
    debugPrint('🔊 NFC Sound: ${_isNfcSoundEnabled ? "ON" : "OFF"}');
  }

  void toggleVibration() {
    _isNfcVibrationEnabled = !_isNfcVibrationEnabled;
    notifyListeners();
    debugPrint('📳 NFC Vibration: ${_isNfcVibrationEnabled ? "ON" : "OFF"}');
  }

  void toggleAndroidBeam() {
    _isAndroidBeamEnabled = !_isAndroidBeamEnabled;
    notifyListeners();
    debugPrint('📡 Android Beam: ${_isAndroidBeamEnabled ? "ON" : "OFF"}');
  }

  void toggleHostCardEmulation() {
    _isHostCardEmulationEnabled = !_isHostCardEmulationEnabled;
    notifyListeners();
    debugPrint('💳 HCE: ${_isHostCardEmulationEnabled ? "ON" : "OFF"}');
  }

  // Start scanning for NFC tags
  void startScan() {
    if (!_isNfcEnabled) {
      debugPrint('⚠️ NFC is disabled, cannot scan');
      return;
    }
    if (_isScanning) {
      debugPrint('⚠️ Already scanning');
      return;
    }

    _isScanning = true;
    notifyListeners();
    debugPrint('🔍 NFC scanning started...');
  }

  // Stop scanning
  void stopScan() {
    if (_isScanning) {
      _isScanning = false;
      notifyListeners();
      debugPrint('🔍 NFC scanning stopped');
    }
  }

  // Called when NFC tag is detected (from native FFI)
  void onTagScanned(String tagData, String tagType) {
    if (!_isNfcEnabled) {
      debugPrint('⚠️ NFC is disabled, tag ignored');
      return;
    }

    _lastScannedTag = tagType;
    _lastTagData = tagData;
    _lastTagType = tagType;

    // Add to history
    _tagHistory.insert(
      0,
      NfcTag(
        name: tagData,
        type: tagType,
        timestamp: DateTime.now(),
        isLocked: false,
      ),
    );

    // Limit history to 20 tags
    if (_tagHistory.length > 20) {
      _tagHistory.removeLast();
    }

    // Play sound if enabled
    if (_isNfcSoundEnabled) {
      _playNfcSound();
    }

    // Vibrate if enabled
    if (_isNfcVibrationEnabled) {
      _vibrate();
    }

    // Stop scanning after tag detected
    _isScanning = false;

    notifyListeners();
    debugPrint('✅ NFC Tag detected: $tagType - $tagData');
  }

  // Called when NFC tag is removed
  void onTagRemoved() {
    if (_lastScannedTag != 'None') {
      _lastScannedTag = 'None';
      notifyListeners();
      debugPrint('📡 NFC Tag removed');
    }
  }

  // Clear tag history
  void clearHistory() {
    _tagHistory.clear();
    _lastScannedTag = 'None';
    _lastTagData = '';
    _lastTagType = '';
    notifyListeners();
    debugPrint('🗑️ NFC history cleared');
  }

  // Remove specific tag from history
  void removeTag(int index) {
    if (index >= 0 && index < _tagHistory.length) {
      _tagHistory.removeAt(index);
      notifyListeners();
      debugPrint('🗑️ NFC tag removed from history');
    }
  }

  // Simulate NFC tag detection (for testing)
  void simulateTagScan(String tagData, String tagType) {
    if (!_isNfcEnabled) {
      debugPrint('⚠️ NFC is disabled, cannot simulate scan');
      return;
    }
    onTagScanned(tagData, tagType);
  }

  // Reset all settings to default
  void resetToDefault() {
    _isNfcEnabled = true;
    _isNfcSoundEnabled = true;
    _isNfcVibrationEnabled = true;
    _isAndroidBeamEnabled = true;
    _isHostCardEmulationEnabled = false;
    _lastScannedTag = 'None';
    _lastTagData = '';
    _lastTagType = '';
    _isScanning = false;
    _tagHistory.clear();
    notifyListeners();
    debugPrint('🔄 NFC settings reset to default');
  }

  // Private methods
  void _playNfcSound() {
    // TODO: Implement with AudioPlayer package
    // Example:
    // final player = AudioPlayer();
    // await player.play(AssetSource('sounds/nfc_tag.mp3'));
    debugPrint('🔊 NFC Sound played');
  }

  void _vibrate() {
    // TODO: Implement with vibration package
    // Example:
    // Vibration.vibrate(duration: 100);
    debugPrint('📳 NFC Vibration');
  }

  // Get tag by index
  NfcTag? getTagAt(int index) {
    if (index >= 0 && index < _tagHistory.length) {
      return _tagHistory[index];
    }
    return null;
  }

  // Get tags count
  int get tagsCount => _tagHistory.length;

  // Check if any tags scanned
  bool get hasTags => _tagHistory.isNotEmpty;

  // Get last scanned time
  DateTime? get lastScannedTime {
    if (_tagHistory.isNotEmpty) {
      return _tagHistory.first.timestamp;
    }
    return null;
  }

  // Get tag statistics
  Map<String, int> getTagStatistics() {
    Map<String, int> stats = {};
    for (var tag in _tagHistory) {
      stats[tag.type] = (stats[tag.type] ?? 0) + 1;
    }
    return stats;
  }

  @override
  void dispose() {
    // Stop scanning when service is disposed
    stopScan();
    super.dispose();
  }
}

// NFC Tag Model
class NfcTag {
  final String name;
  final String type;
  final DateTime timestamp;
  final bool isLocked;

  NfcTag({
    required this.name,
    required this.type,
    required this.timestamp,
    this.isLocked = false,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() => {
    'name': name,
    'type': type,
    'timestamp': timestamp.toIso8601String(),
    'isLocked': isLocked,
  };

  // Create from JSON
  factory NfcTag.fromJson(Map<String, dynamic> json) => NfcTag(
    name: json['name'],
    type: json['type'],
    timestamp: DateTime.parse(json['timestamp']),
    isLocked: json['isLocked'] ?? false,
  );

  @override
  String toString() {
    return 'NfcTag(name: $name, type: $type, time: ${timestamp.toLocal()})';
  }
}