import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:metro_core/services/cellular_service.dart';
import 'package:metro_core/widgets/nfc_status_bar.dart';

class CellularSimPage extends StatefulWidget {
  const CellularSimPage({super.key});

  @override
  State<CellularSimPage> createState() => _CellularSimPageState();
}

class _CellularSimPageState extends State<CellularSimPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CellularService>(context, listen: false).init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cellular & SIM'),
        backgroundColor: Colors.grey[900],
      ),
      body: const Column(
        children: [
          NfcStatusBar(),
          Expanded(
            child: CellularSimContent(),
          ),
        ],
      ),
    );
  }
}

class CellularSimContent extends StatelessWidget {
  const CellularSimContent({super.key});

  @override
  Widget build(BuildContext context) {
    final cellular = Provider.of<CellularService>(context);

    return RefreshIndicator(
      onRefresh: () async {
        cellular.refreshData(context);
        return Future.value();
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // SIM Status Card
          _buildSimStatusCard(cellular, context),
          const SizedBox(height: 16),

          // Data Usage Card
          _buildDataUsageCard(cellular, context),
          const SizedBox(height: 16),

          // Network Settings
          _buildNetworkSettings(cellular, context),
          const SizedBox(height: 16),

          // Operators
          _buildOperatorsSection(cellular, context),
          const SizedBox(height: 16),

          // Reset Button
          _buildResetButton(context, cellular),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSimStatusCard(CellularService cellular, BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  cellular.simStatus.contains('✅') ? Icons.sim_card : Icons.sim_card_alert,
                  color: cellular.simStatus.contains('✅') ? Colors.green : Colors.red,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'SIM Status',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        cellular.simStatus,
                        style: TextStyle(
                          color: cellular.simStatus.contains('✅') ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.blue),
                  onPressed: () {
                    cellular.refreshData(context);
                  },
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 8),
            _buildInfoRow('📱 Phone Number', cellular.phoneNumber),
            _buildInfoRow('🔢 IMEI', cellular.imei),
            _buildInfoRow('📶 Network', cellular.networkType),
            _buildInfoRow('📡 Operator', cellular.operatorName),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildDataUsageCard(CellularService cellular, BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '📊 Data Usage',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Switch(
                  value: cellular.isMobileDataEnabled,
                  onChanged: (_) => cellular.toggleMobileData(),
                  activeColor: Colors.blue,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Used: ${cellular.dataUsed.toStringAsFixed(1)} GB',
                  style: const TextStyle(fontSize: 14),
                ),
                Text(
                  'Total: ${cellular.dataTotal.toStringAsFixed(1)} GB',
                  style: const TextStyle(fontSize: 14),
                ),
                Text(
                  '${cellular.dataRemaining.toStringAsFixed(1)} GB left',
                  style: TextStyle(
                    fontSize: 14,
                    color: cellular.dataRemaining < 1 ? Colors.red : Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: cellular.dataUsagePercent / 100,
              backgroundColor: Colors.grey[300],
              color: cellular.dataUsagePercent > 80 ? Colors.red : Colors.blue,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNetworkSettings(CellularService cellular, BuildContext context) {
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
              '⚙️ Network Settings',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Data Roaming'),
                Switch(
                  value: cellular.isRoamingEnabled,
                  onChanged: (_) => cellular.toggleRoaming(),
                  activeColor: Colors.blue,
                ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Preferred Network'),
                DropdownButton<String>(
                  value: cellular.selectedNetworkType,
                  items: cellular.networkTypes.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      cellular.setNetworkType(value);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOperatorsSection(CellularService cellular, BuildContext context) {
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
              '📡 Network Operators',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (cellular.availableOperators.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('No operators available'),
                ),
              )
            else
              ...cellular.availableOperators.map((operator) => RadioListTile<String>(
                title: Text(operator),
                value: operator,
                groupValue: cellular.selectedOperator,
                onChanged: (value) {
                  if (value != null) {
                    cellular.setOperator(value);
                  }
                },
                activeColor: Colors.blue,
              )),
            if (cellular.availableOperators.isNotEmpty)
              RadioListTile<String>(
                title: const Text('Auto Select'),
                value: 'Auto',
                groupValue: cellular.selectedOperator,
                onChanged: (value) {
                  if (value != null) {
                    cellular.setOperator(value);
                  }
                },
                activeColor: Colors.blue,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildResetButton(BuildContext context, CellularService cellular) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Reset Network Settings'),
              content: const Text('This will reset all cellular network settings to default.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    cellular.resetNetworkSettings();
                    Navigator.pop(context);
                    cellular.showSuccess(context, '✅ Network settings reset');
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
        label: const Text('Reset Network Settings'),
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