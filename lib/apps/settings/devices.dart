import 'package:flutter/material.dart';
import 'package:metro_core/apps/settings/devices/bluetooth_page.dart';
import 'package:metro_core/apps/settings/devices/usb_page.dart';
import 'package:metro_core/apps/settings/devices/nfc_page.dart';
import 'package:metro_core/apps/settings/devices/printers_page.dart';
import 'package:metro_core/apps/settings/devices/mouse_touchpad_page.dart';

class DevicesPage extends StatelessWidget {
  const DevicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Devices'),
        backgroundColor: Colors.grey[900],
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Bluetooth
          _buildDeviceCard(
            context,
            icon: Icons.bluetooth,
            title: 'Bluetooth',
            subtitle: 'Pair and manage Bluetooth devices',
            color: Colors.blue,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BluetoothPage(),
                ),
              );
            },
          ),

          // USB
          _buildDeviceCard(
            context,
            icon: Icons.usb,
            title: 'USB',
            subtitle: 'Manage USB devices and connections',
            color: Colors.green,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UsbPage(),
                ),
              );
            },
          ),

          // NFC
          _buildDeviceCard(
            context,
            icon: Icons.nfc,
            title: 'NFC',
            subtitle: 'Tap to pay and share with NFC tags',
            color: Colors.indigo,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NfcPage(),
                ),
              );
            },
          ),

          // Printers
          _buildDeviceCard(
            context,
            icon: Icons.print,
            title: 'Printers',
            subtitle: 'Add and manage printers',
            color: Colors.purple,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PrintersPage(),
                ),
              );
            },
          ),

          // Mouse & Touchpad
          _buildDeviceCard(
            context,
            icon: Icons.mouse,
            title: 'Mouse & Touchpad',
            subtitle: 'Adjust pointer speed and gestures',
            color: Colors.orange,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MouseTouchpadPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        required Color color,
        required VoidCallback onTap,
      }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.15),
          radius: 28,
          child: Icon(
            icon,
            color: color,
            size: 28,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[600],
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
      ),
    );
  }
}