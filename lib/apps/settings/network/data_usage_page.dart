import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:metro_core/services/data_usage_service.dart';
import 'package:metro_core/widgets/nfc_status_bar.dart';

class DataUsagePage extends StatefulWidget {
  const DataUsagePage({super.key});

  @override
  State<DataUsagePage> createState() => _DataUsagePageState();
}

class _DataUsagePageState extends State<DataUsagePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DataUsageService>(context, listen: false).init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Usage'),
        backgroundColor: Colors.grey[900],
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Provider.of<DataUsageService>(context, listen: false).refreshData();
            },
          ),
        ],
      ),
      body: const Column(
        children: [
          NfcStatusBar(),
          Expanded(
            child: DataUsageContent(),
          ),
        ],
      ),
    );
  }
}

class DataUsageContent extends StatefulWidget {
  const DataUsageContent({super.key});

  @override
  State<DataUsageContent> createState() => _DataUsageContentState();
}

class _DataUsageContentState extends State<DataUsageContent> {
  String _selectedPeriod = 'Today';

  @override
  Widget build(BuildContext context) {
    final dataUsage = Provider.of<DataUsageService>(context);

    return RefreshIndicator(
      onRefresh: () async {
        dataUsage.refreshData();
        return Future.value();
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Period Selector
          _buildPeriodSelector(),
          const SizedBox(height: 16),

          // Total Data Usage Card
          _buildTotalUsageCard(dataUsage),
          const SizedBox(height: 16),

          // Data Usage Breakdown
          _buildDataBreakdown(dataUsage),
          const SizedBox(height: 16),

          // Data Limit
          _buildDataLimitCard(dataUsage),
          const SizedBox(height: 16),

          // App Data Usage
          _buildAppDataUsage(dataUsage),
          const SizedBox(height: 16),

          // Reset Button
          _buildResetButton(context, dataUsage),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector() {
    final periods = ['Today', 'This Week', 'This Month', 'Total'];

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: periods.map((period) {
          final isSelected = period == _selectedPeriod;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedPeriod = period;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  period,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTotalUsageCard(DataUsageService dataUsage) {
    final periodData = _getPeriodData(dataUsage);

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
                const Icon(Icons.data_usage, color: Colors.blue, size: 28),
                const SizedBox(width: 12),
                const Text(
                  'Total Data Usage',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: Column(
                children: [
                  Text(
                    '${periodData.toStringAsFixed(1)} GB',
                    style: const TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  Text(
                    '$_selectedPeriod',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMiniStat(
                  'Cellular',
                  dataUsage.cellularData.today.toStringAsFixed(1),
                  Colors.green,
                ),
                _buildMiniStat(
                  'Wi-Fi',
                  dataUsage.wifiData.today.toStringAsFixed(1),
                  Colors.blue,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  double _getPeriodData(DataUsageService dataUsage) {
    switch (_selectedPeriod) {
      case 'Today':
        return dataUsage.totalData.today;
      case 'This Week':
        return dataUsage.totalData.week;
      case 'This Month':
        return dataUsage.totalData.month;
      case 'Total':
        return dataUsage.totalData.total;
      default:
        return dataUsage.totalData.today;
    }
  }

  Widget _buildMiniStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildDataBreakdown(DataUsageService dataUsage) {
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
              '📊 Data Breakdown',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildBreakdownRow(
              'Cellular Data',
              dataUsage.cellularData,
              Colors.green,
              '📱',
            ),
            const SizedBox(height: 12),
            _buildBreakdownRow(
              'Wi-Fi Data',
              dataUsage.wifiData,
              Colors.blue,
              '📶',
            ),
            const Divider(height: 20),
            _buildBreakdownRow(
              'Total',
              dataUsage.totalData,
              Colors.purple,
              '📊',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBreakdownRow(String label, DataUsage data, Color color, String emoji) {
    double value;
    switch (_selectedPeriod) {
      case 'Today':
        value = data.today;
        break;
      case 'This Week':
        value = data.week;
        break;
      case 'This Month':
        value = data.month;
        break;
      case 'Total':
        value = data.total;
        break;
      default:
        value = data.today;
    }

    return Row(
      children: [
        Text(
          emoji,
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          '${value.toStringAsFixed(2)} GB',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildDataLimitCard(DataUsageService dataUsage) {
    final used = dataUsage.totalData.month;
    final limit = dataUsage.dataLimit;
    final percentage = (used / limit) * 100;

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
              '⚠️ Data Limit',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Used: ${used.toStringAsFixed(1)} GB',
                  style: TextStyle(
                    fontSize: 14,
                    color: percentage > 80 ? Colors.red : Colors.grey,
                  ),
                ),
                Text(
                  'Limit: ${limit.toStringAsFixed(1)} GB',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: Colors.grey[300],
              color: percentage > 80
                  ? Colors.red
                  : percentage > 60
                      ? Colors.orange
                      : Colors.green,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 8),
            Text(
              '${percentage.toStringAsFixed(0)}% used',
              style: TextStyle(
                fontSize: 12,
                color: percentage > 80 ? Colors.red : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppDataUsage(DataUsageService dataUsage) {
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
              '📱 Data Usage by App',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...dataUsage.appDataUsage.map((app) => _buildAppTile(app)),
          ],
        ),
      ),
    );
  }

  Widget _buildAppTile(AppDataUsage app) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: app.color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              app.icon,
              color: app.color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              app.name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            '${app.dataUsed.toStringAsFixed(1)} GB',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: app.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResetButton(BuildContext context, DataUsageService dataUsage) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Reset Data Statistics'),
              content: const Text('This will reset all data usage statistics. Are you sure?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    dataUsage.resetStatistics();
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('✅ Data statistics reset'),
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
        label: const Text('Reset Statistics'),
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
