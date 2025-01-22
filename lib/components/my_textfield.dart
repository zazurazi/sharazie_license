import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
   final controller;
   final String hintText;
   final bool obscureText;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 25.0),
      child: TextField(
        obscureText: true,
        controller: controller,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(130),
          ),
            focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        fillColor: Colors.grey.shade200,
      filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.black)
        ),
      ),
    );
  }
}