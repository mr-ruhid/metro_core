// lib/apps/settings/system/phone.dart

import 'package:flutter/material.dart';
import '../../../ffi/system_ffi.dart';

class PhonePage extends StatefulWidget {
  const PhonePage({super.key});

  @override
  State<PhonePage> createState() => _PhonePageState();
}

class _PhonePageState extends State<PhonePage> {
  String _myNumber = 'Loading...';
  String _voicemailNumber = '';
  int _callerIdMode = 0;
  bool _silenceUnknown = false;
  bool _askReason = false;
  bool _isLoading = true;

  final List<String> _callerIdOptions = ['everyone_text', 'contacts_text', 'no_one_text'];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _myNumber = SystemFFI.getMyNumber();
      _voicemailNumber = SystemFFI.getVoicemailNumber();
      _callerIdMode = SystemFFI.getCallerIdMode();
      _silenceUnknown = SystemFFI.getSilenceUnknown();
      _askReason = SystemFFI.getAskReason();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('phone_text'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        color: Colors.black,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // My number
            _buildInfoTile(
              icon: Icons.phone_android,
              title: 'my_number_text',
              subtitle: _myNumber,
            ),
            const Divider(color: Colors.grey),

            // Voicemail
            _buildInfoTile(
              icon: Icons.voicemail,
              title: 'voicemail_text',
              subtitle: _voicemailNumber,
            ),
            const Divider(color: Colors.grey),

            // Caller ID
            _buildDropdownTile(
              icon: Icons.person,
              title: 'caller_id_text',
              value: _callerIdMode,
              items: _callerIdOptions,
              onChanged: (value) {
                if (value != null) {
                  setState(() => _callerIdMode = value);
                  SystemFFI.setCallerIdMode(value);
                }
              },
            ),
            const Divider(color: Colors.grey),

            // Silence unknown callers
            _buildSwitchTile(
              icon: Icons.volume_off,
              title: 'silence_unknown_text',
              subtitle: 'silence_unknown_desc_text',
              value: _silenceUnknown,
              onChanged: (value) {
                setState(() => _silenceUnknown = value);
                SystemFFI.setSilenceUnknown(value);
              },
            ),
            const Divider(color: Colors.grey),

            // Ask reason before call
            _buildSwitchTile(
              icon: Icons.question_answer,
              title: 'ask_reason_text',
              subtitle: 'ask_reason_desc_text',
              value: _askReason,
              onChanged: (value) {
                setState(() => _askReason = value);
                SystemFFI.setAskReason(value);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
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

  Widget _buildDropdownTile({
    required IconData icon,
    required String title,
    required int value,
    required List<String> items,
    required ValueChanged<int> onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepPurple),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      trailing: DropdownButton<int>(
        value: value,
        dropdownColor: Colors.grey[900],
        style: const TextStyle(color: Colors.white),
        underline: Container(),
        items: items.asMap().entries.map((entry) {
          return DropdownMenuItem<int>(
            value: entry.key,
            child: Text(entry.value),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            onChanged(value);
          }
        },
      ),
    );
  }
}