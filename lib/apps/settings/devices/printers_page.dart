import 'package:flutter/material.dart';

class PrintersPage extends StatefulWidget {
  const PrintersPage({super.key});

  @override
  State<PrintersPage> createState() => _PrintersPageState();
}

class _PrintersPageState extends State<PrintersPage> {
  bool _isPrintingEnabled = true;
  bool _isDefaultPrinterSet = false;
  List<PrinterDevice> _printers = [];
  List<PrinterDevice> _availablePrinters = [];

  @override
  void initState() {
    super.initState();
    _loadPrinters();
  }

  void _loadPrinters() {
    // Simulated printers
    _printers = [
      PrinterDevice(
        name: 'HP LaserJet Pro MFP',
        model: 'MFP M428fdw',
        status: PrinterStatus.ready,
        isDefault: true,
        ipAddress: '192.168.1.101',
        isWireless: true,
      ),
      PrinterDevice(
        name: 'Canon PIXMA TS8350',
        model: 'TS8350',
        status: PrinterStatus.idle,
        isDefault: false,
        ipAddress: '192.168.1.105',
        isWireless: true,
      ),
    ];
    _availablePrinters = [
      PrinterDevice(
        name: 'Brother HL-L2350DW',
        model: 'HL-L2350DW',
        status: PrinterStatus.offline,
        isDefault: false,
        ipAddress: '192.168.1.110',
        isWireless: true,
      ),
      PrinterDevice(
        name: 'Epson EcoTank ET-2750',
        model: 'ET-2750',
        status: PrinterStatus.offline,
        isDefault: false,
        ipAddress: '192.168.1.115',
        isWireless: true,
      ),
    ];
    setState(() {});
  }

  void _togglePrinting() {
    setState(() {
      _isPrintingEnabled = !_isPrintingEnabled;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isPrintingEnabled ? '🖨️ Printing enabled' : '🖨️ Printing disabled',
        ),
        backgroundColor: _isPrintingEnabled ? Colors.green : Colors.grey,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _setDefaultPrinter(PrinterDevice printer) {
    setState(() {
      for (var p in _printers) {
        p.isDefault = false;
      }
      printer.isDefault = true;
      _isDefaultPrinterSet = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✅ ${printer.name} set as default printer'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _addPrinter(PrinterDevice printer) {
    setState(() {
      printer.status = PrinterStatus.ready;
      _printers.add(printer);
      _availablePrinters.remove(printer);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✅ Added: ${printer.name}'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _removePrinter(PrinterDevice printer) {
    setState(() {
      _printers.remove(printer);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🗑️ Removed: ${printer.name}'),
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _printTestPage(PrinterDevice printer) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🖨️ Printing test page on ${printer.name}...'),
        backgroundColor: Colors.blue,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Printers'),
        backgroundColor: Colors.grey[900],
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPrinters,
            tooltip: 'Refresh',
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Add printer dialog
              _showAddPrinterDialog(context);
            },
            tooltip: 'Add printer',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Printer Settings Header
          _buildSettingsHeader(),

          const SizedBox(height: 16),

          // Print Settings
          _buildPrintSettings(),

          const SizedBox(height: 24),

          // My Printers
          const Text(
            '🖨️ My Printers',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          if (_printers.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(Icons.print_disabled, size: 48, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No printers added',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    Text(
                      'Tap the + button to add a printer',
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            )
          else
            ..._printers.map((printer) => _buildPrinterTile(printer, isAdded: true)),

          const SizedBox(height: 24),

          // Available Printers
          if (_availablePrinters.isNotEmpty) ...[
            const Text(
              '📡 Available Printers',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ..._availablePrinters.map((printer) => _buildPrinterTile(printer, isAdded: false)),
          ],
        ],
      ),
    );
  }

  Widget _buildSettingsHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.purple.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.purple.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.print, color: Colors.purple, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Printer Management',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${_printers.length} printer(s) configured',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrintSettings() {
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
              '⚙️ Print Settings',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildSwitchTile(
              icon: Icons.print,
              title: 'Enable Printing',
              subtitle: 'Allow printing from this device',
              value: _isPrintingEnabled,
              onChanged: (_) => _togglePrinting(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.purple),
      title: Text(title),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.purple,
      ),
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildPrinterTile(PrinterDevice printer, {required bool isAdded}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getStatusColor(printer.status).withOpacity(0.2),
          radius: 24,
          child: Icon(
            _getStatusIcon(printer.status),
            color: _getStatusColor(printer.status),
            size: 28,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                printer.name,
                style: TextStyle(
                  fontWeight: printer.isDefault ? FontWeight.bold : FontWeight.normal,
                  fontSize: 15,
                ),
              ),
            ),
            if (printer.isDefault)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Default',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${printer.model} • ${printer.isWireless ? "Wireless" : "Wired"}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(
              'IP: ${printer.ipAddress} • Status: ${_getStatusText(printer.status)}',
              style: TextStyle(
                fontSize: 11,
                color: _getStatusColor(printer.status),
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isAdded && printer.status != PrinterStatus.offline)
              IconButton(
                icon: const Icon(Icons.print, color: Colors.blue),
                onPressed: () => _printTestPage(printer),
                tooltip: 'Test print',
                iconSize: 20,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            if (isAdded && !printer.isDefault && printer.status != PrinterStatus.offline)
              IconButton(
                icon: const Icon(Icons.check_circle_outline, color: Colors.green),
                onPressed: () => _setDefaultPrinter(printer),
                tooltip: 'Set as default',
                iconSize: 20,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            if (isAdded)
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () => _removePrinter(printer),
                tooltip: 'Remove printer',
                iconSize: 20,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            if (!isAdded)
              ElevatedButton(
                onPressed: () => _addPrinter(printer),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  minimumSize: const Size(0, 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Add',
                  style: TextStyle(fontSize: 12),
                ),
              ),
          ],
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
      ),
    );
  }

  void _showAddPrinterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Printer'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Printer Name',
                hintText: 'e.g., Office Printer',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(
                labelText: 'IP Address',
                hintText: 'e.g., 192.168.1.100',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('🔍 Searching for printer...'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              foregroundColor: Colors.white,
            ),
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(PrinterStatus status) {
    switch (status) {
      case PrinterStatus.ready:
        return Colors.green;
      case PrinterStatus.idle:
        return Colors.orange;
      case PrinterStatus.offline:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(PrinterStatus status) {
    switch (status) {
      case PrinterStatus.ready:
        return Icons.check_circle;
      case PrinterStatus.idle:
        return Icons.pending;
      case PrinterStatus.offline:
        return Icons.error_outline;
      default:
        return Icons.print;
    }
  }

  String _getStatusText(PrinterStatus status) {
    switch (status) {
      case PrinterStatus.ready:
        return 'Ready';
      case PrinterStatus.idle:
        return 'Idle';
      case PrinterStatus.offline:
        return 'Offline';
      default:
        return 'Unknown';
    }
  }
}

enum PrinterStatus {
  ready,
  idle,
  offline,
}

class PrinterDevice {
  final String name;
  final String model;
  PrinterStatus status;
  bool isDefault;
  final String ipAddress;
  final bool isWireless;

  PrinterDevice({
    required this.name,
    required this.model,
    required this.status,
    this.isDefault = false,
    required this.ipAddress,
    required this.isWireless,
  });
}