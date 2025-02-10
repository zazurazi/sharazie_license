import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sharazie_license/components/my_textfield.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback showLoginPage;

  const RegisterPage({Key? key, required this.showLoginPage}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _otpController = TextEditingController();
  bool isOtpSent = false; // Track OTP status

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  // Register user and send verification email
  Future<void> signUp() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Send verification email
      await sendEmailVerification(userCredential.user!);
    } catch (e) {
      showError(e.toString());
    }
  }

  // Send OTP Email Verification
  Future<void> sendEmailVerification(User user) async {
    try {
      await user.sendEmailVerification();
      setState(() {
        isOtpSent = true;
      });
      showSuccess('Verification email sent! Check your inbox.');
    } catch (e) {
      showError(e.toString());
    }
  }

  // Verify OTP (Check if email is verified)
  Future<void> verifyOtp() async {
    User? user = FirebaseAuth.instance.currentUser;
    await user?.reload(); // Refresh user info

    if (user != null && user.emailVerified) {
      showSuccess('Email verified! You can now log in.');
      Navigator.pop(context); // Redirect to login
    } else {
      showError('Email not verified. Check your inbox for the verification link.');
    }
  }

  // Show error message
  void showError(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(content: Text(message, style: TextStyle(fontFamily: 'SFProRounded')));
      },
    );
  }

  // Show success message
  void showSuccess(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(content: Text(message, style: TextStyle(fontFamily: 'SFProRounded')));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('lib/assets/logo.jpeg', width: 50, height: 50), // Logo on the left side
                    const SizedBox(width: 0), // Space between logo and title
                    Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 30,
                        fontFamily: 'SFProRounded',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Image.asset('lib/assets/profile.png', width: 200),
                const SizedBox(height: 60),
                MyTextField(
                    controller: _emailController,
                    hintText: 'Email',
                    obscureText: false,
                    textStyle: TextStyle(fontFamily: 'SFProRounded')),
                const SizedBox(height: 15),
                MyTextField(
                    controller: _passwordController,
                    hintText: 'Password',
                    obscureText: true,
                    textStyle: TextStyle(fontFamily: 'SFProRounded')),
                const SizedBox(height: 40),
                if (!isOtpSent)
                  GestureDetector(
                    onTap: signUp,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10), // Adjust padding vertically only for smaller size
                      constraints: BoxConstraints(maxWidth: 110), // Limit the width to make it compact
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17, // Small font size
                            fontFamily: 'SFProRounded',
                          ),
                        ),
                      ),
                    ),
                  ),
                if (isOtpSent) ...[
                  const SizedBox(height: 15),
                  MyTextField(
                    controller: _otpController,
                    hintText: 'Enter OTP Code',
                    obscureText: false,
                    textStyle: TextStyle(fontFamily: 'SFProRounded'),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: verifyOtp,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20), // Smaller button size
                      constraints: BoxConstraints(maxWidth: 200), // Restrict width
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'Verify OTP',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14, // Smaller font size
                            fontFamily: 'SFProRounded',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: widget.showLoginPage,
                  child: Text(
                    'Already have an account? Login',
                    style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontFamily: 'SFProRounded'),
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
