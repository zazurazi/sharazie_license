import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final TextStyle textStyle;
  final Widget? suffixIcon; // Fix: Made nullable to allow 'null' values

  const MyTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.textStyle,
    this.suffixIcon, // Fix: Make optional
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
      child: Material(
        elevation: 8, // Floating effect
        shadowColor: Colors.black26,
        borderRadius: BorderRadius.circular(30),
        child: TextField(
          obscureText: obscureText,
          controller: controller,
          style: textStyle.copyWith(fontFamily: 'SFProRounded'),
          decoration: InputDecoration(
            labelText: hintText,
            labelStyle: const TextStyle(
              fontFamily: 'SFProRounded',
              color: Colors.black,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40.0),
              borderSide: const BorderSide(color: Colors.black, width: 1.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40.0),
              borderSide: const BorderSide(color: Colors.black, width: 1.2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40.0),
              borderSide: const BorderSide(color: Colors.black, width: 1.2),
            ),
            filled: true,
            fillColor: Colors.white60,
            hintText: hintText,
            hintStyle: const TextStyle(
              color: Colors.black45,
              fontFamily: 'SFProRounded',
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            suffixIcon: suffixIcon, // Fix: Use the nullable suffixIcon
          ),
        ),
      ),
    );
  }
}
