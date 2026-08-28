// lib/apps/settings/system/wireless_display.dart

import 'dart:ffi' hide Size;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ffi/ffi.dart';
import '../../../ffi/system_ffi.dart';

class WirelessDisplayPage extends StatefulWidget {
  const WirelessDisplayPage({super.key});

  @override
  State<WirelessDisplayPage> createState() => _WirelessDisplayPageState();
}

class _WirelessDisplayPageState extends State<WirelessDisplayPage> {
  List<String> _devices = [];
  bool _isScanning = false;
  bool _isConnected = false;
  String _status = '';

  void _scanDevices() async {
    setState(() {
      _isScanning = true;
      _devices = [];
      _status = 'searching_text';
    });

    try {
      final result = SystemFFI.discoverDevices();
      final devices = result;

      setState(() {
        _devices = devices.split('\n').where((d) => d.isNotEmpty).toList();
        _isScanning = false;
        _status = _devices.isEmpty ? 'no_devices_text' : 'devices_found_text';
      });
    } catch (e) {
      setState(() {
        _isScanning = false;
        _status = 'error_text';
      });
    }
  }

  void _connectToDevice(String device) async {
    setState(() {
      _status = 'connecting_text';
    });

    try {
      SystemFFI.connectToDevice(device);
      SystemFFI.startStream();

      setState(() {
        _isConnected = true;
        _status = 'connected_text';
      });
    } catch (e) {
      setState(() {
        _status = 'connection_error_text';
      });
    }
  }

  void _disconnect() {
    SystemFFI.stopStream();
    setState(() {
      _isConnected = false;
      _status = 'disconnected_text';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('wireless_display_text'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          children: [
            // Status
            Container(
              padding: const EdgeInsets.all(16),
              child: Text(
                _status.isNotEmpty ? _status : 'scan_hint_text',
                style: TextStyle(
                  color: _status.contains('error') ? Colors.red : Colors.white,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // Scan button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton.icon(
                onPressed: _isScanning ? null : _scanDevices,
                icon: _isScanning
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : const Icon(Icons.refresh),
                label: Text(_isScanning ? 'searching_text' : 'scan_text'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Connected status
            if (_isConnected)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green),
                    const SizedBox(width: 8),
                    const Text(
                      'connected_text',
                      style: TextStyle(color: Colors.white),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: _disconnect,
                      child: const Text(
                        'disconnect_text',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 16),

            // Device list
            Expanded(
              child: _devices.isEmpty && !_isScanning
                  ? Center(
                child: Text(
                  'no_devices_text',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              )
                  : ListView.builder(
                itemCount: _devices.length,
                itemBuilder: (context, index) {
                  final device = _devices[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    color: Colors.grey[900],
                    child: ListTile(
                      leading: const Icon(
                        Icons.tv,
                        color: Colors.deepPurple,
                      ),
                      title: Text(
                        device,
                        style: const TextStyle(color: Colors.white),
                      ),
                      trailing: ElevatedButton(
                        onPressed: _isConnected
                            ? null
                            : () => _connectToDevice(device),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isConnected
                              ? Colors.grey
                              : Colors.deepPurple,
                        ),
                        child: Text(
                          _isConnected ? 'connected_text' : 'connect_text',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}