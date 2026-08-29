import 'package:flutter/material.dart';

class UsbPage extends StatefulWidget {
  const UsbPage({super.key});

  @override
  State<UsbPage> createState() => _UsbPageState();
}

class _UsbPageState extends State<UsbPage> {
  bool _isUsbDebugging = false;
  bool _isFileTransfer = true;
  bool _isUsbCharging = true;
  List<UsbDevice> _usbDevices = [];
  List<UsbDevice> _connectedDevices = [];

  @override
  void initState() {
    super.initState();
    _loadUsbDevices();
  }

  void _loadUsbDevices() {
    // Simulated USB devices
    _usbDevices = [
      UsbDevice(
        name: 'SanDisk Ultra 64GB',
        type: UsbType.storage,
        vendor: 'SanDisk',
        isConnected: false,
        capacity: '64 GB',
        usedSpace: '42 GB',
      ),
      UsbDevice(
        name: 'Logitech Webcam C920',
        type: UsbType.camera,
        vendor: 'Logitech',
        isConnected: false,
      ),
      UsbDevice(
        name: 'Kingston DataTraveler 128GB',
        type: UsbType.storage,
        vendor: 'Kingston',
        isConnected: false,
        capacity: '128 GB',
        usedSpace: '89 GB',
      ),
      UsbDevice(
        name: 'USB Audio Interface',
        type: UsbType.audio,
        vendor: 'Focusrite',
        isConnected: false,
      ),
    ];
    _connectedDevices = [
      UsbDevice(
        name: 'External HDD 1TB',
        type: UsbType.storage,
        vendor: 'Seagate',
        isConnected: true,
        capacity: '1 TB',
        usedSpace: '657 GB',
      ),
      UsbDevice(
        name: 'USB-C Hub',
        type: UsbType.hub,
        vendor: 'Anker',
        isConnected: true,
      ),
    ];
    setState(() {});
  }

  void _toggleUsbDebugging() {
    setState(() {
      _isUsbDebugging = !_isUsbDebugging;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isUsbDebugging ? '🔧 USB Debugging enabled' : '🔧 USB Debugging disabled',
        ),
        backgroundColor: _isUsbDebugging ? Colors.green : Colors.grey,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _toggleFileTransfer() {
    setState(() {
      _isFileTransfer = !_isFileTransfer;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isFileTransfer ? '📁 File Transfer mode enabled' : '📁 File Transfer mode disabled',
        ),
        backgroundColor: _isFileTransfer ? Colors.blue : Colors.grey,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _toggleUsbCharging() {
    setState(() {
      _isUsbCharging = !_isUsbCharging;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isUsbCharging ? '🔋 USB Charging enabled' : '🔋 USB Charging disabled',
        ),
        backgroundColor: _isUsbCharging ? Colors.green : Colors.grey,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _connectDevice(UsbDevice device) {
    setState(() {
      device.isConnected = true;
      _connectedDevices.add(device);
      _usbDevices.remove(device);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✅ Connected: ${device.name}'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _disconnectDevice(UsbDevice device) {
    setState(() {
      device.isConnected = false;
      _connectedDevices.remove(device);
      _usbDevices.add(device);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('❌ Disconnected: ${device.name}'),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _ejectDevice(UsbDevice device) {
    setState(() {
      _connectedDevices.remove(device);
      _usbDevices.remove(device);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('💾 Ejected: ${device.name}'),
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('USB'),
        backgroundColor: Colors.grey[900],
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadUsbDevices,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // USB Settings Header
          _buildSettingsHeader(),

          const SizedBox(height: 16),

          // USB Settings Cards
          _buildUsbSettings(),

          const SizedBox(height: 24),

          // Connected Devices Section
          if (_connectedDevices.isNotEmpty) ...[
            const Text(
              '✅ Connected Devices',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ..._connectedDevices.map((device) => _buildDeviceTile(device, isConnected: true)),
            const SizedBox(height: 16),
          ],

          // Available Devices Section
          const Text(
            '🔌 Available USB Devices',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          if (_usbDevices.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(Icons.usb_off, size: 48, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No USB devices found',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    Text(
                      'Connect a USB device to get started',
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            )
          else
            ..._usbDevices.map((device) => _buildDeviceTile(device, isConnected: false)),
        ],
      ),
    );
  }

  Widget _buildSettingsHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.usb, color: Colors.blue, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'USB Management',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${_connectedDevices.length} device(s) connected',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsbSettings() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '⚙️ USB Settings',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildSwitchTile(
              icon: Icons.developer_mode,
              title: 'USB Debugging',
              subtitle: 'Allow debugging when USB is connected',
              value: _isUsbDebugging,
              onChanged: (_) => _toggleUsbDebugging(),
            ),
            const Divider(),
            _buildSwitchTile(
              icon: Icons.folder_open,
              title: 'File Transfer',
              subtitle: 'Enable file transfer over USB',
              value: _isFileTransfer,
              onChanged: (_) => _toggleFileTransfer(),
            ),
            const Divider(),
            _buildSwitchTile(
              icon: Icons.battery_charging_full,
              title: 'USB Charging',
              subtitle: 'Charge device via USB connection',
              value: _isUsbCharging,
              onChanged: (_) => _toggleUsbCharging(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.blue,
      ),
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildDeviceTile(UsbDevice device, {required bool isConnected}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isConnected ? Colors.green.withOpacity(0.2) : Colors.grey[300],
          radius: 24,
          child: Icon(
            _getUsbIcon(device.type),
            color: isConnected ? Colors.green : Colors.grey[600],
            size: 28,
          ),
        ),
        title: Text(
          device.name,
          style: TextStyle(
            fontWeight: isConnected ? FontWeight.bold : FontWeight.normal,
            fontSize: 15,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${device.vendor} • ${_getTypeName(device.type)}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            if (device.capacity != null)
              Text(
                '📊 ${device.capacity} • Used: ${device.usedSpace}',
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isConnected)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Connected',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const SizedBox(width: 8),
            if (isConnected && device.type != UsbType.hub)
              IconButton(
                icon: const Icon(Icons.sd_storage, color: Colors.orange),
                onPressed: () => _ejectDevice(device),
                tooltip: 'Eject',
                iconSize: 20,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            if (isConnected)
              IconButton(
                icon: const Icon(Icons.usb_off, color: Colors.red),
                onPressed: () => _disconnectDevice(device),
                tooltip: 'Disconnect',
                iconSize: 20,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            if (!isConnected)
              ElevatedButton(
                onPressed: () => _connectDevice(device),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  minimumSize: const Size(0, 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Connect',
                  style: TextStyle(fontSize: 12),
                ),
              ),
          ],
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
      ),
    );
  }

  IconData _getUsbIcon(UsbType type) {
    switch (type) {
      case UsbType.storage:
        return Icons.sd_storage;
      case UsbType.camera:
        return Icons.videocam;
      case UsbType.audio:
        return Icons.audiotrack;
      case UsbType.hub:
        return Icons.usb;
      default:
        return Icons.usb;
    }
  }

  String _getTypeName(UsbType type) {
    switch (type) {
      case UsbType.storage:
        return 'Storage';
      case UsbType.camera:
        return 'Camera';
      case UsbType.audio:
        return 'Audio';
      case UsbType.hub:
        return 'Hub';
      default:
        return 'Device';
    }
  }
}

enum UsbType {
  storage,
  camera,
  audio,
  hub,
}

class UsbDevice {
  final String name;
  final UsbType type;
  final String vendor;
  bool isConnected;
  final String? capacity;
  final String? usedSpace;

  UsbDevice({
    required this.name,
    required this.type,
    required this.vendor,
    this.isConnected = false,
    this.capacity,
    this.usedSpace,
  });
}