// lib/pages/driving_mode_page.dart
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class DrivingModePage extends StatefulWidget {
  const DrivingModePage({super.key});

  @override
  State<DrivingModePage> createState() => _DrivingModePageState();
}

class _DrivingModePageState extends State<DrivingModePage> {
  String _track = "Yüklənir...";
  double _lat = 0.0;
  double _lon = 0.0;
  int _notifications = 0;
  bool _isLoading = true;

  // WebSocket kanalı
  WebSocketChannel? _channel;

  @override
  void initState() {
    super.initState();
    _connectToPhone();
  }

  // Telefonla WebSocket əlaqəsi yarat
  void _connectToPhone() {
    // Real sistemdə telefonun IP ünvanını yaz
    // Məsələn: ws://192.168.1.100:8080
    final uri = Uri.parse('ws://192.168.1.100:8080');

    try {
      _channel = WebSocketChannel.connect(uri);
      _channel!.stream.listen((message) {
        // Telefondan gələn JSON məlumatı qəbul et
        Map<String, dynamic> data = jsonDecode(message);
        setState(() {
          _track = data['track'];
          _lat = data['lat'];
          _lon = data['lon'];
          _notifications = data['notifications'];
          _isLoading = false;
        });
      }, onError: (error) {
        // Əgər əlaqə xətası olsa, simulyasiya rejiminə keç
        _simulateData();
      });
    } catch (e) {
      // Əgər WebSocket açılmırsa, simulyasiya rejiminə keç
      _simulateData();
    }
  }

  // Simulyasiya rejimi (cihaz tapılmadıqda)
  void _simulateData() {
    String jsonString = '{"track": "Metro Core", "lat": 40.4093, "lon": 49.8671, "notifications": 3}';
    Map<String, dynamic> data = jsonDecode(jsonString);
    setState(() {
      _track = data['track'];
      _lat = data['lat'];
      _lon = data['lon'];
      _notifications = data['notifications'];
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _channel?.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Driving Mode', style: TextStyle(color: Colors.white)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hazırkı Mahnı: $_track', style: const TextStyle(color: Colors.white, fontSize: 22)),
            const SizedBox(height: 20),
            Text('GPS: $_lat, $_lon', style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),
            Text('Bildirişlər: $_notifications', style: const TextStyle(color: Colors.cyanAccent)),
          ],
        ),
      ),
    );
  }
}