// lib/pages/settings/device_encryption_page.dart
import 'package:flutter/material.dart';
import '../../../../services/device_encryption_service.dart';

class DeviceEncryptionPage extends StatefulWidget {
  const DeviceEncryptionPage({super.key});

  @override
  State<DeviceEncryptionPage> createState() => _DeviceEncryptionPageState();
}

class _DeviceEncryptionPageState extends State<DeviceEncryptionPage> {
  final DeviceEncryptionService _encryptionService = DeviceEncryptionService();

  bool _isLoading = true;
  bool _isEncryptionEnabled = false;
  String _algorithm = 'AES-256-XTS';
  bool _isPinSet = false;

  @override
  void initState() {
    super.initState();
    _loadEncryptionStatus();
  }

  Future<void> _loadEncryptionStatus() async {
    setState(() {
      _isLoading = true;
    });

    bool status = await _encryptionService.checkEncryptionStatus();

    setState(() {
      _isEncryptionEnabled = status;
      _algorithm = 'AES-256-XTS';
      _isPinSet = true;
      _isLoading = false;
    });
  }

  Future<void> _toggleEncryption(bool value) async {
    setState(() {
      _isLoading = true;
    });

    String result;
    if (value) {
      result = await _encryptionService.enableEncryption("1234");
    } else {
      result = await _encryptionService.disableEncryption("1234");
    }

    setState(() {
      _isEncryptionEnabled = value;
      _isLoading = false;
    });

    if (result != 'Uğurlu') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'device_encryption_title',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(color: Colors.white),
      )
          : Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'device_encryption_desc',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 30),

            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1F1F1F),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white12),
              ),
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'device_encryption_label',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'linux_luks_dmcrypt',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Switch(
                    value: _isEncryptionEnabled,
                    onChanged: _toggleEncryption,
                    activeColor: Colors.cyanAccent,
                    inactiveThumbColor: Colors.grey,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            const Text('system_info_label', style: TextStyle(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 10),

            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1F1F1F),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.key, color: Colors.cyanAccent),
                    title: const Text('encryption_algorithm_label', style: TextStyle(color: Colors.white)),
                    trailing: Text(
                      _algorithm,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                  const Divider(color: Colors.white12, height: 1),
                  ListTile(
                    leading: const Icon(Icons.lock_outline, color: Colors.cyanAccent),
                    title: const Text('pin_password_label', style: TextStyle(color: Colors.white)),
                    trailing: _isPinSet
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : const Icon(Icons.error, color: Colors.red),
                  ),
                ],
              ),
            ),

            const Spacer(),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber),
              ),
              child: const Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: Colors.amber),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'encryption_warning_text',
                      style: TextStyle(color: Colors.amber, fontSize: 12, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}