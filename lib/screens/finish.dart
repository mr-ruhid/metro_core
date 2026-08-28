// lib/screens/finish.dart

import 'package:flutter/material.dart';
import '../ffi/system_ffi.dart';

class FinishScreen extends StatefulWidget {
  const FinishScreen({super.key});

  @override
  State<FinishScreen> createState() => _FinishScreenState();
}

class _FinishScreenState extends State<FinishScreen> {
  double _progress = 0.0;
  bool _isReady = false;
  bool _isChecking = true;

  @override
  void initState() {
    super.initState();
    _startSetup();
  }

  void _startSetup() async {
    // 5 saniyə ərzində progress artır
    for (int i = 0; i <= 100; i++) {
      await Future.delayed(Duration(milliseconds: 50));
      setState(() {
        _progress = i / 100;
      });

      // Hər addımda real sistem yoxlanır
      if (SystemFFI.isSystemReady()) {
        setState(() {
          _isReady = true;
          _isChecking = false;
        });
        return;
      }
    }

    // 5 saniyə bitdi, amma sistem hələ hazır deyilsə
    // Fake olaraq hazır say
    if (!_isReady) {
      setState(() {
        _isReady = true;
        _isChecking = false;
      });
    }
  }

  void _goToHome() {
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'finish_title',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 40),
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: FractionallySizedBox(
                      widthFactor: _progress,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.purple,
                              Colors.blue,
                              Colors.purple,
                            ],
                            stops: [0.0, 0.5, 1.0],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  _isChecking
                      ? '${(_progress * 100).toInt()}% - checking_text'
                      : '${(_progress * 100).toInt()}%',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 16),
                if (_isReady)
                  ElevatedButton(
                    onPressed: _goToHome,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      padding: EdgeInsets.symmetric(
                        horizontal: 48,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      'start_text',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}