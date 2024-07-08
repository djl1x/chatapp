// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
    final Widget? prefixIcon; 
    final String labelText;
    final bool obscureText; 
    final TextEditingController controller;

  const MyTextField({
    super.key,
    this.prefixIcon,
    required this.labelText,
    required this.obscureText,
    required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        labelText: labelText,
        border: OutlineInputBorder(),
      ),
    );
  }
}