// lib/screens/wifi.dart

import 'package:flutter/material.dart';
import '../ffi/system_ffi.dart';

class WifiScreen extends StatefulWidget {
  const WifiScreen({super.key});

  @override
  State<WifiScreen> createState() => _WifiScreenState();
}

class _WifiScreenState extends State<WifiScreen> {
  bool _isScanning = true;
  bool _isConnected = false;
  String _selectedNetwork = '';
  List<Map<String, dynamic>> _networks = [];
  String _password = '';
  bool _showPasswordDialog = false;

  @override
  void initState() {
    super.initState();
    _scanWifi();
  }

  void _scanWifi() async {
    setState(() {
      _isScanning = true;
      _networks = [];
    });

    try {
      final networks = await SystemFFI.scanWifi();
      setState(() {
        _networks = networks;
        _isScanning = false;
      });
    } catch (e) {
      setState(() {
        _isScanning = false;
      });
    }
  }

  void _connectToNetwork(String ssid) async {
    setState(() {
      _selectedNetwork = ssid;
    });

    // Şifrəli şəbəkədirsə, dialoq aç
    final network = _networks.firstWhere((n) => n['ssid'] == ssid);
    if (network['secured'] == true) {
      _showPasswordDialog = true;
      _showPasswordDialogFunc(ssid);
    } else {
      // Açıq şəbəkəyə birbaşa qoşul
      final result = await SystemFFI.connectWifi(ssid, '');
      if (result) {
        setState(() {
          _isConnected = true;
        });
      }
    }
  }

  void _showPasswordDialogFunc(String ssid) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          'wifi_password_title',
          style: const TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$ssid',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'wifi_password_hint',
                hintStyle: const TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[800]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.purple),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                _password = value;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showPasswordDialog = false;
            },
            child: const Text(
              'cancel_text',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              _showPasswordDialog = false;
              final result = await SystemFFI.connectWifi(ssid, _password);
              if (result) {
                setState(() {
                  _isConnected = true;
                });
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
            ),
            child: const Text(
              'connect_text',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _goToUpdate() {
    Navigator.pushReplacementNamed(context, '/update');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // Başlıq
                const Text(
                  'wifi_title',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'wifi_subtitle',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 24),

                // Siyahı
                Expanded(
                  child: _isScanning
                      ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.purple,
                    ),
                  )
                      : _networks.isEmpty
                      ? const Center(
                    child: Text(
                      'no_wifi_text',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                      : ListView.builder(
                    itemCount: _networks.length,
                    itemBuilder: (context, index) {
                      final network = _networks[index];
                      final isSelected =
                          _selectedNetwork == network['ssid'];
                      return _buildNetworkItem(
                        network['ssid'],
                        network['secured'] ?? false,
                        network['signal'] ?? 0,
                        isSelected,
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // Yenilə düyməsi
                TextButton(
                  onPressed: _scanWifi,
                  child: const Text(
                    'refresh_text',
                    style: TextStyle(color: Colors.purple),
                  ),
                ),

                const SizedBox(height: 16),

                // Davam / Keç düyməsi
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _goToUpdate,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[800],
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'skip_text',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isConnected ? _goToUpdate : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          _isConnected ? Colors.purple : Colors.grey[800],
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          _isConnected ? 'continue_text' : 'connect_first_text',
                          style: TextStyle(
                            color: _isConnected ? Colors.white : Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNetworkItem(String ssid, bool secured, int signal, bool selected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: selected ? Colors.purple.withOpacity(0.2) : Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: selected ? Colors.purple : Colors.transparent,
          width: 2,
        ),
      ),
      child: ListTile(
        leading: Icon(
          secured ? Icons.lock : Icons.wifi,
          color: selected ? Colors.purple : Colors.white,
        ),
        title: Text(
          ssid,
          style: TextStyle(
            color: selected ? Colors.purple : Colors.white,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSignalIcon(signal),
            if (selected && _isConnected)
              const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Icon(Icons.check_circle, color: Colors.green, size: 20),
              ),
          ],
        ),
        onTap: () {
          if (!selected) {
            _connectToNetwork(ssid);
          }
        },
      ),
    );
  }

  Widget _buildSignalIcon(int signal) {
    IconData icon;
    if (signal >= 80) {
      icon = Icons.wifi;
    } else if (signal >= 50) {
      icon = Icons.wifi;
    } else if (signal >= 30) {
      icon = Icons.wifi;
    } else {
      icon = Icons.wifi;
    }
    return Icon(icon, color: Colors.grey, size: 20);
  }
}