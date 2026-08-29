import 'package:flutter/material.dart';

class MouseTouchpadPage extends StatefulWidget {
  const MouseTouchpadPage({super.key});

  @override
  State<MouseTouchpadPage> createState() => _MouseTouchpadPageState();
}

class _MouseTouchpadPageState extends State<MouseTouchpadPage> {
  // Mouse Settings
  double _pointerSpeed = 0.5;
  bool _isMouseEnabled = true;
  bool _isNaturalScrolling = true;
  bool _isTapToClick = false;
  bool _isTwoFingerScroll = true;
  bool _isThreeFingerSwipe = true;
  bool _isPointerAcceleration = true;

  // Touchpad Settings
  double _touchpadSensitivity = 0.5;
  bool _isTouchpadEnabled = true;
  bool _isPalmRejection = true;
  bool _isEdgeScrolling = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mouse & Touchpad'),
        backgroundColor: Colors.grey[900],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Mouse Section
          _buildSectionHeader(
            icon: Icons.mouse,
            title: 'Mouse',
            color: Colors.orange,
          ),
          const SizedBox(height: 8),

          // Mouse Enable/Disable
          _buildToggleCard(
            icon: Icons.mouse,
            title: 'Enable Mouse',
            subtitle: 'Turn mouse input on or off',
            value: _isMouseEnabled,
            color: Colors.orange,
            onChanged: (value) {
              setState(() {
                _isMouseEnabled = value;
              });
            },
          ),

          const SizedBox(height: 12),

          // Pointer Speed
          _buildSliderCard(
            icon: Icons.speed,
            title: 'Pointer Speed',
            subtitle: 'Adjust mouse pointer speed',
            value: _pointerSpeed,
            color: Colors.orange,
            onChanged: (value) {
              setState(() {
                _pointerSpeed = value;
              });
            },
          ),

          const SizedBox(height: 12),

          // Mouse Options
          _buildSwitchCard(
            icon: Icons.swap_vert,
            title: 'Natural Scrolling',
            subtitle: 'Scroll direction matches touch gestures',
            value: _isNaturalScrolling,
            color: Colors.orange,
            onChanged: (value) {
              setState(() {
                _isNaturalScrolling = value;
              });
            },
          ),

          const SizedBox(height: 12),

          _buildSwitchCard(
            icon: Icons.trending_up,
            title: 'Pointer Acceleration',
            subtitle: 'Speed increases with faster movements',
            value: _isPointerAcceleration,
            color: Colors.orange,
            onChanged: (value) {
              setState(() {
                _isPointerAcceleration = value;
              });
            },
          ),

          const SizedBox(height: 24),

          // Touchpad Section
          _buildSectionHeader(
            icon: Icons.laptop,
            title: 'Touchpad',
            color: Colors.teal,
          ),
          const SizedBox(height: 8),

          // Touchpad Enable/Disable
          _buildToggleCard(
            icon: Icons.laptop,
            title: 'Enable Touchpad',
            subtitle: 'Turn touchpad input on or off',
            value: _isTouchpadEnabled,
            color: Colors.teal,
            onChanged: (value) {
              setState(() {
                _isTouchpadEnabled = value;
              });
            },
          ),

          const SizedBox(height: 12),

          // Touchpad Sensitivity
          _buildSliderCard(
            icon: Icons.tune,
            title: 'Touchpad Sensitivity',
            subtitle: 'Adjust touchpad sensitivity level',
            value: _touchpadSensitivity,
            color: Colors.teal,
            onChanged: (value) {
              setState(() {
                _touchpadSensitivity = value;
              });
            },
          ),

          const SizedBox(height: 12),

          // Touchpad Gestures
          _buildSwitchCard(
            icon: Icons.touch_app,
            title: 'Tap to Click',
            subtitle: 'Tap touchpad to perform left-click',
            value: _isTapToClick,
            color: Colors.teal,
            onChanged: (value) {
              setState(() {
                _isTapToClick = value;
              });
            },
          ),

          const SizedBox(height: 12),

          _buildSwitchCard(
            icon: Icons.swipe,
            title: 'Two-Finger Scroll',
            subtitle: 'Use two fingers to scroll',
            value: _isTwoFingerScroll,
            color: Colors.teal,
            onChanged: (value) {
              setState(() {
                _isTwoFingerScroll = value;
              });
            },
          ),

          const SizedBox(height: 12),

          _buildSwitchCard(
            icon: Icons.swipe_up,
            title: 'Three-Finger Swipe',
            subtitle: 'Use three fingers to switch apps',
            value: _isThreeFingerSwipe,
            color: Colors.teal,
            onChanged: (value) {
              setState(() {
                _isThreeFingerSwipe = value;
              });
            },
          ),

          const SizedBox(height: 12),

          _buildSwitchCard(
            icon: Icons.touch_app,
            title: 'Palm Rejection',
            subtitle: 'Prevent accidental touches while typing',
            value: _isPalmRejection,
            color: Colors.teal,
            onChanged: (value) {
              setState(() {
                _isPalmRejection = value;
              });
            },
          ),

          const SizedBox(height: 12),

          _buildSwitchCard(
            icon: Icons.settings_overscan,
            title: 'Edge Scrolling',
            subtitle: 'Scroll using touchpad edges',
            value: _isEdgeScrolling,
            color: Colors.teal,
            onChanged: (value) {
              setState(() {
                _isEdgeScrolling = value;
              });
            },
          ),

          const SizedBox(height: 24),

          // Reset Button
          Center(
            child: ElevatedButton.icon(
              onPressed: _resetSettings,
              icon: const Icon(Icons.restore),
              label: const Text('Reset to Default'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildToggleCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Color color,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: color,
              activeTrackColor: color.withOpacity(0.3),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Color color,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: color,
              activeTrackColor: color.withOpacity(0.3),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliderCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required double value,
    required Color color,
    required ValueChanged<double> onChanged,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${(value * 100).round()}%',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Slider(
              value: value,
              onChanged: onChanged,
              min: 0.0,
              max: 1.0,
              activeColor: color,
              inactiveColor: color.withOpacity(0.2),
              divisions: 10,
              label: '${(value * 100).round()}%',
            ),
          ],
        ),
      ),
    );
  }

  void _resetSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Settings'),
        content: const Text(
          'Are you sure you want to reset all mouse and touchpad settings to default?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _pointerSpeed = 0.5;
                _isMouseEnabled = true;
                _isNaturalScrolling = true;
                _isTapToClick = false;
                _isTwoFingerScroll = true;
                _isThreeFingerSwipe = true;
                _isPointerAcceleration = true;
                _touchpadSensitivity = 0.5;
                _isTouchpadEnabled = true;
                _isPalmRejection = true;
                _isEdgeScrolling = false;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('✅ Settings reset to default'),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}