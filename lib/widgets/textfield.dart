//textfield.dart
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final String? label;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType? inputType; // Add this parameter
  final double borderRadius; // Add borderRadius parameter

  const CustomTextField({
    super.key,
    required this.hint,
    this.label,
    required this.controller,
    this.isPassword = false,
    this.inputType, // Initialize it here
    this.borderRadius = 10.0, // Set a default value for borderRadius
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: inputType, // Use it here
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hint,
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius), // Apply borderRadius here
        ),
      ),
    );
  }
}
