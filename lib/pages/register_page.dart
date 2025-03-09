import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sharazie_license/components/my_textfield.dart';
import 'loginScreen.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback showLoginPage;

  const RegisterPage({Key? key, required this.showLoginPage}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _fullNameController = TextEditingController(); // Name Controller
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Register user and store role in Firestore
  Future<void> signUp() async {
    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Save user info in Firestore with role 'user' & name
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'name': _fullNameController.text.trim(), // Storing Name
        'email': _emailController.text.trim(),
        'role': 'user',
        'created_at': FieldValue.serverTimestamp(),
      });

      // Send email verification
      await sendEmailVerification(userCredential.user!);
    } catch (e) {
      showError(e.toString());
    }
  }

  // Send Email Verification
  Future<void> sendEmailVerification(User user) async {
    try {
      await user.sendEmailVerification();
      showSuccess('Verification email sent! Check your inbox.');
    } catch (e) {
      showError(e.toString());
    }
  }

  // Show error message
  void showError(String message) {
    Future.delayed(Duration.zero, () {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(message, style: const TextStyle(fontFamily: 'SFProRounded')),
          );
        },
      );
    });
  }

  // Show success message
  void showSuccess(String message) {
    Future.delayed(Duration.zero, () {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(message, style: const TextStyle(fontFamily: 'SFProRounded')),
          );
        },
      );
    });
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
                    Image.asset('lib/assets/logo.jpeg', width: 50, height: 50),
                    const SizedBox(width: 0),
                    const Text(
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

                // Name Field
                MyTextField(
                  controller: _fullNameController,
                  hintText: 'Full Name',
                  obscureText: false,
                  textStyle: const TextStyle(fontFamily: 'SFProRounded'),
                  suffixIcon: null,
                ),
                const SizedBox(height: 6),

                // Email Field
                MyTextField(
                  controller: _emailController,
                  hintText: 'Email',
                  obscureText: false,
                  textStyle: const TextStyle(fontFamily: 'SFProRounded'),
                  suffixIcon: null,
                ),
                const SizedBox(height: 6),

                // Password Field with Visibility Toggle
                MyTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                  obscureText: !_isPasswordVisible,
                  textStyle: const TextStyle(fontFamily: 'SFProRounded'),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 40),

                // Signup Button
                GestureDetector(
                  onTap: signUp,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    constraints: const BoxConstraints(maxWidth: 110),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontFamily: 'SFProRounded',
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Login Redirection
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginPage(showRegisterPage: widget.showLoginPage)),
                    );
                  },
                  child: const Text.rich(
                    TextSpan(
                      text: 'Already have an account? ',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SFProRounded',
                        fontSize: 20,
                      ),
                      children: [
                        TextSpan(
                          text: 'Login',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SFProRounded',
                            fontSize: 20,
                          ),
                        ),
                      ],
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
