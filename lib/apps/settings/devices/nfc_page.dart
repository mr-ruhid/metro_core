import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:metro_core/services/nfc_service.dart';
import 'package:metro_core/widgets/nfc_status_bar.dart';

class NfcPage extends StatelessWidget {   // ✅ Class adı: NfcPage
  const NfcPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NFC'),
        backgroundColor: Colors.grey[900],
      ),
      body: const Column(
        children: [
          NfcStatusBar(),
          Expanded(
            child: NfcContent(),
          ),
        ],
      ),
    );
  }
}

class NfcContent extends StatefulWidget {  // ✅ Content class
  const NfcContent({super.key});

  @override
  State<NfcContent> createState() => _NfcContentState();
}

class _NfcContentState extends State<NfcContent> {
  @override
  Widget build(BuildContext context) {
    final nfcService = Provider.of<NfcService>(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildNfcHeader(nfcService),
        const SizedBox(height: 16),
        _buildNfcSettings(nfcService),
        const SizedBox(height: 24),
        _buildRecentTags(nfcService),
      ],
    );
  }

  Widget _buildNfcHeader(NfcService nfcService) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: nfcService.isNfcEnabled
            ? Colors.blue.withOpacity(0.1)
            : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: nfcService.isNfcEnabled
              ? Colors.blue.withOpacity(0.2)
              : Colors.grey.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.nfc,
            color: nfcService.isNfcEnabled ? Colors.blue : Colors.grey,
            size: 40,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nfcService.isNfcEnabled ? 'NFC is On' : 'NFC is Off',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  nfcService.isNfcEnabled
                      ? 'Tap to share or scan tags'
                      : 'Enable NFC to use tap & pay',
                  style: TextStyle(
                    fontSize: 13,
                    color: nfcService.isNfcEnabled
                        ? Colors.grey[600]
                        : Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: nfcService.isNfcEnabled,
            onChanged: (_) => nfcService.toggleNfc(),
            activeColor: Colors.blue,
            activeTrackColor: Colors.blue.withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildNfcSettings(NfcService nfcService) {
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
              '⚙️ NFC Settings',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildSwitchTile(
              icon: Icons.share,
              title: 'Android Beam',
              subtitle: 'Share content by touching devices',
              value: nfcService.isAndroidBeamEnabled,
              onChanged: (_) => nfcService.toggleAndroidBeam(),
              color: Colors.blue,
            ),
            const Divider(),
            _buildSwitchTile(
              icon: Icons.volume_up,
              title: 'NFC Sound',
              subtitle: 'Play sound when tag is detected',
              value: nfcService.isNfcSoundEnabled,
              onChanged: (_) => nfcService.toggleSound(),
              color: Colors.blue,
            ),
            const Divider(),
            _buildSwitchTile(
              icon: Icons.vibration,
              title: 'NFC Vibration',
              subtitle: 'Vibrate when tag is detected',
              value: nfcService.isNfcVibrationEnabled,
              onChanged: (_) => nfcService.toggleVibration(),
              color: Colors.blue,
            ),
            const Divider(),
            _buildSwitchTile(
              icon: Icons.credit_card,
              title: 'Host Card Emulation',
              subtitle: 'Pay using your phone (HCE)',
              value: nfcService.isHostCardEmulationEnabled,
              onChanged: (_) => nfcService.toggleHostCardEmulation(),
              color: Colors.green,
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
    required Color color,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 12),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: color,
        activeTrackColor: color.withOpacity(0.3),
      ),
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildRecentTags(NfcService nfcService) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '📋 Recent Tags',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (nfcService.tagHistory.isNotEmpty)
              TextButton(
                onPressed: nfcService.clearHistory,
                child: const Text(
                  'Clear All',
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        if (nfcService.tagHistory.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Column(
                children: [
                  Icon(Icons.nfc, size: 48, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No tags scanned',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  Text(
                    'Hold phone near a tag',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ),
          )
        else
          ...nfcService.tagHistory.map((tag) => _buildTagTile(tag)),
      ],
    );
  }

  Widget _buildTagTile(NfcTag tag) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: tag.isLocked
              ? Colors.red.withOpacity(0.2)
              : Colors.blue.withOpacity(0.2),
          radius: 22,
          child: Icon(
            tag.isLocked ? Icons.lock : Icons.tag,
            color: tag.isLocked ? Colors.red : Colors.blue,
            size: 22,
          ),
        ),
        title: Text(
          tag.name,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tag.type,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(
              _formatTimestamp(tag.timestamp),
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
        trailing: tag.isLocked
            ? Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            'Locked',
            style: TextStyle(
              color: Colors.red,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
            : null,
      ),
    );
  }

  String _formatTimestamp(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} minute(s) ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} hour(s) ago';
    } else {
      return '${difference.inDays} day(s) ago';
    }
  }
}