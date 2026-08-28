// lib/apps/settings/system/about_page.dart
import 'package:flutter/material.dart';
import '../../../../ffi/system_ffi.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String _kernelVersion = "";
  String _cpuModel = "";
  double _ramTotal = 0.0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInfo();
  }

  void _loadInfo() {
    _kernelVersion = SystemFFI.getKernelVersion();
    _cpuModel = SystemFFI.getCpuModel();
    _ramTotal = SystemFFI.getRamTotal();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('about_title', style: TextStyle(color: Colors.white)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: Colors.cyanAccent,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.memory, color: Colors.black, size: 40),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                'app_name',
                style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 5),
            Center(
              child: Text(
                'version_label: 1.0.0',
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
            const SizedBox(height: 30),

            const Text('system_info_label', style: TextStyle(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1F1F1F),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.memory, color: Colors.cyanAccent),
                    title: const Text('kernel_label', style: TextStyle(color: Colors.white)),
                    trailing: Text(
                      _kernelVersion,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                  const Divider(color: Colors.white12, height: 1),
                  ListTile(
                    leading: const Icon(Icons.computer, color: Colors.cyanAccent),
                    title: const Text('cpu_label', style: TextStyle(color: Colors.white)),
                    trailing: Text(
                      _cpuModel,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                  const Divider(color: Colors.white12, height: 1),
                  ListTile(
                    leading: const Icon(Icons.storage, color: Colors.cyanAccent),
                    title: const Text('ram_label', style: TextStyle(color: Colors.white)),
                    trailing: Text(
                      '${_ramTotal.toStringAsFixed(1)} GB',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text('copyright_text', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}