import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:metro_core/services/nfc_service.dart';

class NfcStatusBar extends StatelessWidget {
  const NfcStatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NfcService>(
      builder: (context, nfcService, child) {
        // NFC disabled state
        if (!nfcService.isNfcEnabled) {
          return Container(
            height: 30,
            color: Colors.grey[850],
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.nfc,
                  size: 16,
                  color: Colors.grey,
                ),
                const SizedBox(width: 6),
                Text(
                  'NFC is disabled',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          );
        }

        // NFC enabled state
        return Container(
          height: 30,
          color: Colors.blue.withOpacity(0.08),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left side - NFC Status
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: nfcService.isScanning ? Colors.orange : Colors.blue,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      nfcService.isScanning ? Icons.nfc : Icons.nfc,
                      size: 16,
                      color: nfcService.isScanning ? Colors.orange : Colors.blue,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        nfcService.isScanning
                            ? 'Scanning for tags...'
                            : (nfcService.lastScannedTag != 'None'
                            ? 'Tag: ${nfcService.lastScannedTag}'
                            : 'NFC active • Hold phone near tag'),
                        style: TextStyle(
                          fontSize: 11,
                          color: nfcService.lastScannedTag != 'None'
                              ? Colors.green
                              : (nfcService.isScanning ? Colors.orange : Colors.blue),
                          fontWeight: nfcService.lastScannedTag != 'None'
                              ? FontWeight.w500
                              : FontWeight.normal,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              // Right side - Tag info if detected
              if (nfcService.lastScannedTag != 'None') ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 4,
                        height: 4,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${nfcService.tagsCount} tags',
                        style: TextStyle(
                          fontSize: 9,
                          color: Colors.green[300],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // Scanning indicator
              if (nfcService.isScanning) ...[
                const SizedBox(width: 8),
                SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.orange[300]!),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}