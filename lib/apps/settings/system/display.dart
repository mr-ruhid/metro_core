import 'package:flutter/material.dart';
import '../../../ffi/system_ffi.dart';
import 'wireless_display.dart';  // ← BUNU ƏLAVƏ ET

class DisplayPage extends StatefulWidget {
  const DisplayPage({super.key});

  @override
  State<DisplayPage> createState() => _DisplayPageState();
}

class _DisplayPageState extends State<DisplayPage> {
  double _brightness = 50;
  bool _autoBrightness = true;
  bool _rotationLock = false;
  bool _touchDot = true;

  @override
  void initState() {
    super.initState();
    _loadBrightness();
  }

  void _loadBrightness() {
    final value = SystemFFI.getBrightness();
    setState(() {
      _brightness = value.toDouble();
    });
  }

  void _setBrightness(double value) {
    setState(() {
      _brightness = value;
    });
    SystemFFI.setBrightness(value.toInt());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('display_text'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        color: Colors.black,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSliderTile(
              icon: Icons.brightness_6,
              title: 'brightness_text',
              value: _brightness,
              onChanged: _setBrightness,
            ),
            const Divider(color: Colors.grey),

            _buildSwitchTile(
              icon: Icons.brightness_auto,
              title: 'auto_brightness_text',
              value: _autoBrightness,
              onChanged: (value) {
                setState(() => _autoBrightness = value);
              },
            ),
            const Divider(color: Colors.grey),

            _buildSwitchTile(
              icon: Icons.screen_rotation,
              title: 'rotation_lock_text',
              value: _rotationLock,
              onChanged: (value) {
                setState(() => _rotationLock = value);
              },
            ),
            const Divider(color: Colors.grey),

            _buildSwitchTile(
              icon: Icons.touch_app,
              title: 'touch_dot_text',
              value: _touchDot,
              onChanged: (value) {
                setState(() => _touchDot = value);
              },
            ),
            const Divider(color: Colors.grey),

            ListTile(
              leading: const Icon(Icons.screen_share, color: Colors.deepPurple),
              title: const Text(
                'connect_wireless_display_text',
                style: TextStyle(color: Colors.white),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WirelessDisplayPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliderTile({
    required IconData icon,
    required String title,
    required double value,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.deepPurple),
          title: Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
          trailing: Text(
            '${value.toInt()}%',
            style: const TextStyle(color: Colors.grey),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Slider(
            value: value,
            min: 0,
            max: 100,
            divisions: 10,
            activeColor: Colors.deepPurple,
            inactiveColor: Colors.grey[800],
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepPurple),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.deepPurple,
      ),
    );
  }
}