// lib/widgets/password_input_widget.dart
import 'package:flutter/material.dart';
import 'package:gotta_go/constants/constant.dart';

class PasswordInputWidget extends StatefulWidget {
  final IconData iconName;
  final String hintText;
  final String labelText;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const PasswordInputWidget({
    super.key,
    required this.iconName,
    required this.hintText,
    required this.labelText,
    required this.controller,
    this.validator,
  });

  @override
  State<PasswordInputWidget> createState() => _PasswordInputWidgetState();
}

class _PasswordInputWidgetState extends State<PasswordInputWidget> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _isObscured,
      decoration: InputDecoration(
        prefixIcon: Icon(widget.iconName),
        hintText: widget.hintText,
        labelText: widget.labelText,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Constants.buttonColor, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 13),
        suffixIcon: IconButton(
          icon: Icon(
            _isObscured ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            setState(() {
              _isObscured = !_isObscured;
            });
          },
        ),
      ),
      validator: widget.validator,
    );
  }
}