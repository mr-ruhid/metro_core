// lib/apps/settings/system/storage.dart

import 'package:flutter/material.dart';
import '../../../ffi/system_ffi.dart';

class StoragePage extends StatefulWidget {
  const StoragePage({super.key});

  @override
  State<StoragePage> createState() => _StoragePageState();
}

class _StoragePageState extends State<StoragePage> {
  double _totalSpace = 32.0;
  double _usedSpace = 9.16;
  double _freeSpace = 19.96;
  bool _lowStorageWarning = true;
  bool _isLoading = true;

  final List<Map<String, dynamic>> _categories = [
    {'icon': Icons.image, 'name': 'images_text', 'size': 1.2, 'color': Colors.blue},
    {'icon': Icons.video_library, 'name': 'videos_text', 'size': 3.5, 'color': Colors.red},
    {'icon': Icons.audiotrack, 'name': 'audio_text', 'size': 0.8, 'color': Colors.green},
    {'icon': Icons.archive, 'name': 'mtx_packages_text', 'size': 2.1, 'color': Colors.purple},
    {'icon': Icons.apps, 'name': 'apps_text', 'size': 1.6, 'color': Colors.orange},
    {'icon': Icons.folder, 'name': 'other_text', 'size': 0.2, 'color': Colors.grey},
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _totalSpace = SystemFFI.getTotalStorage();
      _usedSpace = SystemFFI.getUsedStorage();
      _freeSpace = _totalSpace - _usedSpace;
      _lowStorageWarning = SystemFFI.getLowStorageWarning();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('storage_text'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        color: Colors.black,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildStorageOverview(),
            const SizedBox(height: 24),
            const Text(
              'categories_text',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ..._categories.map((category) {
              return _buildCategoryTile(
                icon: category['icon'],
                name: category['name'],
                size: category['size'],
                color: category['color'],
              );
            }).toList(),
            const SizedBox(height: 24),
            const Text(
              'system_settings_text',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildSwitchTile(
              icon: Icons.warning,
              title: 'low_storage_warning_text',
              subtitle: 'low_storage_warning_desc_text',
              value: _lowStorageWarning,
              onChanged: (value) {
                setState(() => _lowStorageWarning = value);
                SystemFFI.setLowStorageWarning(value);
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'future_features_text',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildFutureTile(
              icon: Icons.history,
              title: 'file_history_text',
              subtitle: 'file_history_desc_text',
            ),
            _buildFutureTile(
              icon: Icons.sd_storage,
              title: 'sd_card_text',
              subtitle: 'sd_card_desc_text',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStorageOverview() {
    double usedPercent = _usedSpace / _totalSpace;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.storage, color: Colors.deepPurple, size: 40),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'total_storage_text ${_totalSpace.toStringAsFixed(1)} GB',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: usedPercent,
                      backgroundColor: Colors.grey[800],
                      color: usedPercent > 0.85 ? Colors.red : Colors.deepPurple,
                      minHeight: 8,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${_usedSpace.toStringAsFixed(2)} GB used_text',
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        Text(
                          '${_freeSpace.toStringAsFixed(2)} GB free_text',
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTile({
    required IconData icon,
    required String name,
    required double size,
    required Color color,
  }) {
    double maxSize = 10.0;
    double percent = size / maxSize;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        name,
        style: const TextStyle(color: Colors.white),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${size.toStringAsFixed(1)} GB',
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 60,
            child: LinearProgressIndicator(
              value: percent > 1.0 ? 1.0 : percent,
              backgroundColor: Colors.grey[800],
              color: color,
              minHeight: 6,
            ),
          ),
        ],
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
      leading: Icon(icon, color: Colors.deepPurple),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: Colors.grey),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.deepPurple,
      ),
    );
  }

  Widget _buildFutureTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: Colors.grey),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
      onTap: _showFutureDialog,
    );
  }

  void _showFutureDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'coming_soon_text',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'coming_soon_desc_text',
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'ok_text',
              style: TextStyle(color: Colors.deepPurple),
            ),
          ),
        ],
      ),
    );
  }
}