import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth/main_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveOtpVerifiedStatus(bool status) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('otp_verified', status);
}

String _decryptOTP(String encryptedOTP) {
  return encryptedOTP.split('').reversed.join();
}

class OtpVerificationPage extends StatefulWidget {
  final String userId;
  const OtpVerificationPage({Key? key, required this.userId}) : super(key: key);

  @override
  _OtpVerificationPageState createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final _otpController = TextEditingController();
  bool _isVerifying = false;

  Future<void> _verifyOTP() async {
    setState(() => _isVerifying = true);
    try {
      final doc = await FirebaseFirestore.instance
          .collection('otp_verification')
          .doc(widget.userId)
          .get();

      if (doc.exists) {
        final encryptedOTP = doc.data()?['otp'];
        final storedOTP = _decryptOTP(encryptedOTP);
        final enteredOTP = _otpController.text.trim();

        // Debugging: Print values for verification
        print("Debugging OTP verification:");
        print("Encrypted OTP from Firebase: $encryptedOTP");
        print("Decrypted OTP from Firebase: $storedOTP");
        print("Entered OTP by User: $enteredOTP");

        if (enteredOTP == storedOTP) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(widget.userId)
              .set({'isOtpVerified': true}, SetOptions(merge: true));

          await saveOtpVerifiedStatus(true);

          await FirebaseFirestore.instance
              .collection('otp_verification')
              .doc(widget.userId)
              .delete();

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainPage()),
          );
        } else {
          _showError("Incorrect OTP. Try again.");
        }
      } else {
        _showError("OTP expired. Please log in again.");
      }
    } catch (e) {
      _showError("Error verifying OTP: $e");
    }
    setState(() => _isVerifying = false);
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(content: Text(message));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Enter OTP", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter OTP',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isVerifying ? null : _verifyOTP,
                child: _isVerifying ? CircularProgressIndicator() : Text("Verify"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
