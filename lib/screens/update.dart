// lib/screens/update.dart

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../ffi/system_ffi.dart';

class UpdateScreen extends StatefulWidget {
  const UpdateScreen({super.key});

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  bool _isChecking = true;
  bool _hasUpdate = false;
  bool _isDownloading = false;
  double _downloadProgress = 0.0;
  String _statusText = 'checking_text';
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _checkForUpdates();
  }

  void _checkForUpdates() async {
    setState(() {
      _isChecking = true;
      _statusText = 'checking_text';
      _errorMessage = '';
    });

    try {
      final result = await SystemFFI.checkForUpdates();

      setState(() {
        _isChecking = false;
        _hasUpdate = result['hasUpdate'];
        if (!_hasUpdate) {
          _statusText = 'no_update_text';
        }
      });
    } catch (e) {
      setState(() {
        _isChecking = false;
        _hasUpdate = false;
        _errorMessage = 'error_text';
      });
    }
  }

  void _startDownload() async {
    setState(() {
      _isDownloading = true;
      _statusText = 'downloading_text';
      _downloadProgress = 0.0;
    });

    try {
      await SystemFFI.downloadUpdate((progress) {
        setState(() {
          _downloadProgress = progress;
        });
      });

      setState(() {
        _isDownloading = false;
        _statusText = 'download_complete_text';
      });
    } catch (e) {
      setState(() {
        _isDownloading = false;
        _statusText = 'download_error_text';
      });
    }
  }

  void _goToFinish() {
    Navigator.pushReplacementNamed(context, '/finish');
  }

  void _openGitHub() async {
    final Uri url = Uri.parse('https://github.com/mr-ruhid/metro_core');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStatusIcon(),
                const SizedBox(height: 24),

                Text(
                  _errorMessage.isNotEmpty ? _errorMessage : _statusText,
                  style: TextStyle(
                    color: _errorMessage.isNotEmpty ? Colors.red : Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                if (_errorMessage.isNotEmpty) ...[
                  TextButton(
                    onPressed: _openGitHub,
                    child: const Text(
                      'github_link_text',
                      style: TextStyle(
                        color: Colors.purple,
                        fontSize: 14,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],

                if (_isDownloading) ...[
                  const SizedBox(height: 32),
                  Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: FractionallySizedBox(
                        widthFactor: _downloadProgress,
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.purple, Colors.blue],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${(_downloadProgress * 100).toInt()}%',
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],

                const Spacer(),

                // Düymələr
                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIcon() {
    if (_isChecking) {
      return const SizedBox(
        width: 60,
        height: 60,
        child: CircularProgressIndicator(color: Colors.purple),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return const Icon(Icons.error_outline, color: Colors.red, size: 60);
    }

    if (_hasUpdate) {
      return const Icon(Icons.system_update, color: Colors.orange, size: 60);
    }

    return const Icon(Icons.check_circle, color: Colors.green, size: 60);
  }

  Widget _buildActionButtons() {
    // Yükləmə zamanı
    if (_isDownloading) {
      return Container();
    }

    // Xəta olsa da KEÇ butonu aktivdir
    if (_errorMessage.isNotEmpty) {
      return Column(
        children: [
          ElevatedButton(
            onPressed: _goToFinish,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[800],
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              'skip_text',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      );
    }

    // Update var
    if (_hasUpdate) {
      return Column(
        children: [
          // Yüklə düyməsi
          ElevatedButton(
            onPressed: _startDownload,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              'download_now_text',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          const SizedBox(height: 12),
          // Daha sonra et
          TextButton(
            onPressed: _goToFinish,
            child: const Text(
              'later_text',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
        ],
      );
    }

    // Update yoxdur
    return ElevatedButton(
      onPressed: _goToFinish,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[800],
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: const Text(
        'skip_text',
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}