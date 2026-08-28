// lib/apps/settings/system/charge.dart

import 'package:flutter/material.dart';
import '../../../ffi/system_ffi.dart';

class ChargePage extends StatefulWidget {
  const ChargePage({super.key});

  @override
  State<ChargePage> createState() => _ChargePageState();
}

class _ChargePageState extends State<ChargePage> {
  int _batteryLevel = 0;
  int _remaining = 0;
  int _chargingTime = 0;
  bool _fastCharging = true;
  bool _reverseCharging = false;
  bool _aiProtection = true;
  bool _batteryBypass = false;
  bool _chargingSecurity = true;
  bool _isLoading = true;
  bool _isReverseSupported = false;
  bool _isBypassSupported = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _batteryLevel = SystemFFI.getBatteryLevel();
      _remaining = SystemFFI.getBatteryRemaining();
      _chargingTime = SystemFFI.getBatteryChargingTime();
      _fastCharging = SystemFFI.getFastCharging();
      _reverseCharging = SystemFFI.getReverseCharging();
      _aiProtection = SystemFFI.getAiProtection();
      _batteryBypass = SystemFFI.getBatteryBypass();
      _chargingSecurity = SystemFFI.getChargingSecurity();
      _isReverseSupported = SystemFFI.isReverseChargingSupported();
      _isBypassSupported = SystemFFI.isBatteryBypassSupported();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('charge_text'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        color: Colors.black,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // === Battery status ===
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.battery_std,
                        color: _batteryLevel > 20 ? Colors.green : Colors.red,
                        size: 40,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$_batteryLevel%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            LinearProgressIndicator(
                              value: _batteryLevel / 100,
                              backgroundColor: Colors.grey[800],
                              color: _batteryLevel > 20 ? Colors.green : Colors.red,
                              minHeight: 8,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.timer, color: Colors.grey, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'remaining_time_text $_remaining min',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.flash_on, color: Colors.green, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'charging_time_text $_chargingTime min',
                        style: const TextStyle(color: Colors.green),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // === Charging settings ===
            const Text(
              'charging_settings_text',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // 1. Fast charging
            ListTile(
              leading: const Icon(Icons.speed, color: Colors.deepPurple),
              title: const Text(
                'fast_charging_text',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: const Text(
                'fast_charging_desc_text',
                style: TextStyle(color: Colors.grey),
              ),
              trailing: Switch(
                value: _fastCharging,
                onChanged: (value) {
                  setState(() => _fastCharging = value);
                  SystemFFI.setFastCharging(value);
                },
                activeColor: Colors.deepPurple,
              ),
            ),

            // 2. Reverse charging
            ListTile(
              leading: const Icon(Icons.usb, color: Colors.deepPurple),
              title: const Text(
                'reverse_charging_text',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                _isReverseSupported
                    ? 'reverse_charging_desc_text'
                    : 'unsupported_text',
                style: TextStyle(
                  color: _isReverseSupported ? Colors.grey : Colors.red,
                ),
              ),
              trailing: Switch(
                value: _reverseCharging,
                onChanged: _isReverseSupported
                    ? (value) {
                  setState(() => _reverseCharging = value);
                  SystemFFI.setReverseCharging(value);
                  if (value) {
                    _showSnackBar('reverse_charging_active_text');
                  }
                }
                    : null,
                activeColor: Colors.deepPurple,
              ),
            ),

            // 3. AI Charging Protection
            ListTile(
              leading: const Icon(Icons.auto_awesome, color: Colors.deepPurple),
              title: const Text(
                'ai_charging_text',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: const Text(
                'ai_charging_desc_text',
                style: TextStyle(color: Colors.grey),
              ),
              trailing: Switch(
                value: _aiProtection,
                onChanged: (value) {
                  setState(() => _aiProtection = value);
                  SystemFFI.setAiProtection(value);
                },
                activeColor: Colors.deepPurple,
              ),
            ),

            // 4. Battery Bypass
            ListTile(
              leading: const Icon(Icons.bolt, color: Colors.deepPurple),
              title: const Text(
                'battery_bypass_text',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                _isBypassSupported
                    ? 'battery_bypass_desc_text'
                    : 'unsupported_text',
                style: TextStyle(
                  color: _isBypassSupported ? Colors.grey : Colors.red,
                ),
              ),
              trailing: Switch(
                value: _batteryBypass,
                onChanged: _isBypassSupported
                    ? (value) {
                  setState(() => _batteryBypass = value);
                  SystemFFI.setBatteryBypass(value);
                  if (value) {
                    _showSnackBar('bypass_supported_text');
                  }
                }
                    : null,
                activeColor: Colors.deepPurple,
              ),
            ),

            // 5. Charging Security
            ListTile(
              leading: const Icon(Icons.security, color: Colors.deepPurple),
              title: const Text(
                'charging_security_text',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: const Text(
                'charging_security_desc_text',
                style: TextStyle(color: Colors.grey),
              ),
              trailing: Switch(
                value: _chargingSecurity,
                onChanged: (value) {
                  setState(() => _chargingSecurity = value);
                  SystemFFI.setChargingSecurity(value);
                },
                activeColor: Colors.deepPurple,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: Colors.grey[900],
        duration: const Duration(seconds: 2),
      ),
    );
  }
}