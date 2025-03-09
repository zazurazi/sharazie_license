import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SystemConfigPage extends StatefulWidget {
  @override
  _SystemConfigPageState createState() => _SystemConfigPageState();
}

class _SystemConfigPageState extends State<SystemConfigPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _feeController = TextEditingController();
  final TextEditingController _expirationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() async {
    DocumentSnapshot doc = await _firestore.collection('settings').doc('license_config').get();
    if (doc.exists) {
      _feeController.text = doc['license_fee'].toString();
      _expirationController.text = doc['license_expiration'].toString();
    }
  }

  Future<void> _saveSettings() async {
    await _firestore.collection('settings').doc('license_config').set({
      'license_fee': double.parse(_feeController.text),
      'license_expiration': int.parse(_expirationController.text),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Settings updated!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("System Configurations")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _feeController, decoration: InputDecoration(labelText: "License Fee")),
            TextField(controller: _expirationController, decoration: InputDecoration(labelText: "License Expiration (Days)")),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _saveSettings, child: Text("Save Settings")),
          ],
        ),
      ),
    );
  }
}