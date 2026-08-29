import 'package:flutter/material.dart';

class BluetoothPage extends StatefulWidget {
  const BluetoothPage({super.key});

  @override
  State<BluetoothPage> createState() => _BluetoothPageState();
}

class _BluetoothPageState extends State<BluetoothPage> {
  bool _isBluetoothOn = true;
  bool _isScanning = false;
  List<BluetoothDevice> _devices = [];
  List<BluetoothDevice> _pairedDevices = [];

  @override
  void initState() {
    super.initState();
    _loadDevices();
  }

  void _loadDevices() {
    // Simulated data - real implementation will use FFI
    _devices = [
      BluetoothDevice(
        name: 'Sony WH-1000XM4',
        address: 'AA:BB:CC:DD:EE:01',
        isPaired: false,
        isConnected: false,
        rssi: -45,
      ),
      BluetoothDevice(
        name: 'JBL Flip 5',
        address: 'AA:BB:CC:DD:EE:02',
        isPaired: false,
        isConnected: false,
        rssi: -62,
      ),
      BluetoothDevice(
        name: 'Logitech MX Keys',
        address: 'AA:BB:CC:DD:EE:03',
        isPaired: false,
        isConnected: false,
        rssi: -78,
      ),
      BluetoothDevice(
        name: 'iPhone 15 Pro',
        address: 'AA:BB:CC:DD:EE:04',
        isPaired: false,
        isConnected: false,
        rssi: -55,
      ),
      BluetoothDevice(
        name: 'Xiaomi Mi Band 7',
        address: 'AA:BB:CC:DD:EE:05',
        isPaired: false,
        isConnected: false,
        rssi: -70,
      ),
    ];
    _pairedDevices = [
      BluetoothDevice(
        name: 'Samsung Galaxy Buds',
        address: '11:22:33:44:55:01',
        isPaired: true,
        isConnected: false,
        rssi: -30,
      ),
      BluetoothDevice(
        name: 'MacBook Pro',
        address: '11:22:33:44:55:02',
        isPaired: true,
        isConnected: true,
        rssi: -25,
      ),
      BluetoothDevice(
        name: 'Sony TV',
        address: '11:22:33:44:55:03',
        isPaired: true,
        isConnected: false,
        rssi: -50,
      ),
    ];
    setState(() {});
  }

  void _toggleBluetooth() {
    setState(() {
      _isBluetoothOn = !_isBluetoothOn;
      if (!_isBluetoothOn) {
        _devices.clear();
        _pairedDevices.clear();
      } else {
        _loadDevices();
      }
    });
  }

  void _startScan() {
    if (!_isBluetoothOn) return;
    setState(() {
      _isScanning = true;
      _devices.clear();
    });
    // Simulate scan
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _isScanning = false;
        _loadDevices();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🔍 Scan complete! Found devices.'),
          duration: Duration(seconds: 2),
        ),
      );
    });
  }

  void _connectDevice(BluetoothDevice device) {
    setState(() {
      device.isPaired = true;
      device.isConnected = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✅ Connected to ${device.name}'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _disconnectDevice(BluetoothDevice device) {
    setState(() {
      device.isConnected = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('❌ Disconnected from ${device.name}'),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _forgetDevice(BluetoothDevice device) {
    setState(() {
      _pairedDevices.remove(device);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🗑️ Forgot ${device.name}'),
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _pairDevice(BluetoothDevice device) {
    setState(() {
      device.isPaired = true;
      device.isConnected = true;
      _pairedDevices.add(device);
      _devices.remove(device);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🔗 Paired with ${device.name}'),
        backgroundColor: Colors.blue,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth'),
        backgroundColor: Colors.grey[900],
        actions: [
          IconButton(
            icon: Icon(
              _isBluetoothOn ? Icons.bluetooth : Icons.bluetooth_disabled,
              color: _isBluetoothOn ? Colors.blue : Colors.grey,
            ),
            onPressed: _toggleBluetooth,
            tooltip: _isBluetoothOn ? 'Turn off' : 'Turn on',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Paired Devices Section
                if (_pairedDevices.isNotEmpty) ...[
                  const Text(
                    '📌 Paired Devices',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ..._pairedDevices.map((device) => _buildDeviceTile(device, isPaired: true)),
                  const SizedBox(height: 24),
                ],
                // Available Devices Section
                const Text(
                  '🔍 Available Devices',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                if (_isScanning)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Column(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text(
                            'Scanning for devices...',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  )
                else if (_devices.isEmpty && _isBluetoothOn)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Icon(Icons.bluetooth_searching, size: 48, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'No devices found',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          Text(
                            'Tap the scan button to search',
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  )
                else if (_devices.isEmpty && !_isBluetoothOn)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: Column(
                          children: [
                            Icon(Icons.bluetooth_disabled, size: 48, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              'Bluetooth is off',
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                            Text(
                              'Turn on Bluetooth to find devices',
                              style: TextStyle(fontSize: 13, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ..._devices.map((device) => _buildDeviceTile(device, isPaired: false)),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (_isBluetoothOn && !_isScanning) ? _startScan : null,
        icon: Icon(_isScanning ? Icons.stop : Icons.search),
        label: Text(_isScanning ? 'Scanning...' : 'Scan for Devices'),
        backgroundColor: _isBluetoothOn ? Colors.blue : Colors.grey,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _isBluetoothOn ? Colors.blue.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isBluetoothOn ? Colors.blue.withOpacity(0.2) : Colors.grey.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            _isBluetoothOn ? Icons.bluetooth_connected : Icons.bluetooth_disabled,
            color: _isBluetoothOn ? Colors.blue : Colors.grey,
            size: 40,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isBluetoothOn ? 'Bluetooth is On' : 'Bluetooth is Off',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _isBluetoothOn
                      ? '${_pairedDevices.where((d) => d.isConnected).length} device(s) connected • ${_pairedDevices.length} paired'
                      : 'Tap the toggle to enable Bluetooth',
                  style: TextStyle(
                    fontSize: 13,
                    color: _isBluetoothOn ? Colors.grey[600] : Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: _isBluetoothOn,
            onChanged: (_) => _toggleBluetooth(),
            activeColor: Colors.blue,
            activeTrackColor: Colors.blue.withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceTile(BluetoothDevice device, {required bool isPaired}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: device.isConnected
              ? Colors.green
              : isPaired
              ? Colors.blue.withOpacity(0.2)
              : Colors.grey[300],
          radius: 24,
          child: Icon(
            device.isConnected
                ? Icons.bluetooth_connected
                : isPaired
                ? Icons.check
                : Icons.bluetooth,
            color: device.isConnected
                ? Colors.white
                : isPaired
                ? Colors.blue
                : Colors.grey[600],
            size: 20,
          ),
        ),
        title: Text(
          device.name,
          style: TextStyle(
            fontWeight: device.isConnected ? FontWeight.bold : FontWeight.normal,
            fontSize: 15,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              device.address,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            if (device.rssi != null)
              Text(
                'Signal: ${device.rssi} dBm',
                style: TextStyle(
                  fontSize: 11,
                  color: device.rssi! > -50 ? Colors.green : Colors.grey,
                ),
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Status Badge
            if (device.isConnected)
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
              )
            else if (isPaired)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Paired',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const SizedBox(width: 8),
            // Action Buttons
            if (isPaired && device.isConnected)
              IconButton(
                icon: const Icon(Icons.link_off, color: Colors.red),
                onPressed: () => _disconnectDevice(device),
                tooltip: 'Disconnect',
                iconSize: 20,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            if (isPaired && !device.isConnected)
              IconButton(
                icon: const Icon(Icons.link, color: Colors.blue),
                onPressed: () => _connectDevice(device),
                tooltip: 'Connect',
                iconSize: 20,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            if (isPaired)
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () => _forgetDevice(device),
                tooltip: 'Forget device',
                iconSize: 20,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            if (!isPaired && _isBluetoothOn)
              ElevatedButton(
                onPressed: () => _pairDevice(device),
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
                  'Pair',
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
}

class BluetoothDevice {
  final String name;
  final String address;
  bool isPaired;
  bool isConnected;
  final int? rssi;

  BluetoothDevice({
    required this.name,
    required this.address,
    this.isPaired = false,
    this.isConnected = false,
    this.rssi,
  });
}