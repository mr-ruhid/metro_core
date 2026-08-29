import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:metro_core/services/airplane_mode_service.dart';
import 'package:metro_core/services/wifi_service.dart';
import 'package:metro_core/widgets/nfc_status_bar.dart';

class AirplaneModePage extends StatefulWidget {
  const AirplaneModePage({super.key});

  @override
  State<AirplaneModePage> createState() => _AirplaneModePageState();
}

class _AirplaneModePageState extends State<AirplaneModePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final airplaneService = Provider.of<AirplaneModeService>(context, listen: false);
      airplaneService.init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Airplane Mode'),
        backgroundColor: Colors.grey[900],
      ),
      body: const Column(
        children: [
          NfcStatusBar(),
          Expanded(
            child: AirplaneModeContent(),
          ),
        ],
      ),
    );
  }
}

class AirplaneModeContent extends StatelessWidget {
  const AirplaneModeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final airplane = Provider.of<AirplaneModeService>(context);
    final wifi = Provider.of<WifiService>(context, listen: false);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Airplane Mode Header
        _buildAirplaneHeader(airplane),
        const SizedBox(height: 20),

        // Airplane Mode Description
        _buildDescription(airplane),
        const SizedBox(height: 20),

        // Individual Toggles
        _buildIndividualToggles(airplane, context),
        const SizedBox(height: 20),

        // Info Card
        _buildInfoCard(airplane),
        const SizedBox(height: 20),

        // Reset Button
        _buildResetButton(context, airplane),
      ],
    );
  }

  Widget _buildAirplaneHeader(AirplaneModeService airplane) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: airplane.isAirplaneMode
              ? [Colors.orange.shade900, Colors.orange.shade700]
              : [Colors.grey.shade800, Colors.grey.shade700],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: airplane.isAirplaneMode
                ? Colors.orange.withOpacity(0.3)
                : Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // ✅ Düzəliş: Icons.flight
              Icon(
                airplane.isAirplaneMode ? Icons.flight : Icons.flight_takeoff,
                color: Colors.white,
                size: 48,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      airplane.isAirplaneMode ? 'Airplane Mode is On' : 'Airplane Mode is Off',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      airplane.isAirplaneMode
                          ? 'All wireless connections are disabled'
                          : 'All wireless connections are enabled',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: airplane.isAirplaneMode,
                onChanged: (_) => airplane.toggleAirplaneMode(),
                activeColor: Colors.white,
                activeTrackColor: Colors.orange.shade300,
                inactiveThumbColor: Colors.grey.shade300,
                inactiveTrackColor: Colors.grey.shade600,
              ),
            ],
          ),
          if (airplane.isAirplaneMode) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.white.withOpacity(0.9),
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'You can manually turn on Wi-Fi or Bluetooth',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDescription(AirplaneModeService airplane) {
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
                Icon(
                  Icons.info_outline,
                  color: airplane.isAirplaneMode ? Colors.orange : Colors.blue,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    airplane.isAirplaneMode
                        ? 'Airplane mode turns off all wireless connections. You can still use Wi-Fi and Bluetooth by turning them on individually.'
                        : 'Airplane mode is off. All wireless connections are available.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIndividualToggles(AirplaneModeService airplane, BuildContext context) {
    final wifi = Provider.of<WifiService>(context);

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
              'Individual Connections',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Turn on/off connections individually',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),

            // Wi-Fi Toggle
            _buildConnectionTile(
              icon: Icons.wifi,
              title: 'Wi-Fi',
              subtitle: wifi.isWifiEnabled ? 'Connected' : 'Disabled',
              value: wifi.isWifiEnabled,
              onChanged: (value) {
                wifi.toggleWifi();
              },
              color: wifi.isWifiEnabled ? Colors.blue : Colors.grey,
              isAirplaneMode: airplane.isAirplaneMode,
            ),

            const Divider(),

            // Bluetooth Toggle
            _buildConnectionTile(
              icon: Icons.bluetooth,
              title: 'Bluetooth',
              subtitle: airplane.isBluetoothEnabled ? 'Connected' : 'Disabled',
              value: airplane.isBluetoothEnabled,
              onChanged: (value) {
                airplane.toggleBluetooth();
              },
              color: airplane.isBluetoothEnabled ? Colors.blue : Colors.grey,
              isAirplaneMode: airplane.isAirplaneMode,
            ),

            const Divider(),

            // Cellular Toggle
            _buildConnectionTile(
              icon: Icons.signal_cellular_alt,
              title: 'Cellular Data',
              subtitle: airplane.isCellularEnabled ? 'Active' : 'Disabled',
              value: airplane.isCellularEnabled,
              onChanged: (value) {
                airplane.toggleCellular();
              },
              color: airplane.isCellularEnabled ? Colors.green : Colors.grey,
              isAirplaneMode: airplane.isAirplaneMode,
            ),

            const Divider(),

            // Hotspot Toggle
            _buildConnectionTile(
              icon: Icons.wifi_tethering,
              title: 'Hotspot',
              subtitle: airplane.isHotspotEnabled ? 'Active' : 'Disabled',
              value: airplane.isHotspotEnabled,
              onChanged: (value) {
                airplane.toggleHotspot();
              },
              color: airplane.isHotspotEnabled ? Colors.purple : Colors.grey,
              isAirplaneMode: airplane.isAirplaneMode,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required Color color,
    required bool isAirplaneMode,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: isAirplaneMode && !value ? Colors.grey.shade600 : Colors.grey.shade500,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: color,
        activeTrackColor: color.withOpacity(0.3),
      ),
    );
  }

  Widget _buildInfoCard(AirplaneModeService airplane) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '📊 Connection Status',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildStatusRow('✈️ Airplane Mode', airplane.isAirplaneMode ? 'On' : 'Off'),
            _buildStatusRow('📶 Wi-Fi', airplane.isWifiEnabled ? 'On' : 'Off'),
            _buildStatusRow('📡 Bluetooth', airplane.isBluetoothEnabled ? 'On' : 'Off'),
            _buildStatusRow('📱 Cellular', airplane.isCellularEnabled ? 'On' : 'Off'),
            _buildStatusRow('🔥 Hotspot', airplane.isHotspotEnabled ? 'On' : 'Off'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: value == 'On' ? Colors.green : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResetButton(BuildContext context, AirplaneModeService airplane) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Reset All Connections'),
              content: const Text('This will turn off airplane mode and enable all connections.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    airplane.resetAll();
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('✅ All connections reset'),
                        backgroundColor: Colors.green,
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
        },
        icon: const Icon(Icons.restore),
        label: const Text('Reset All Connections'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}