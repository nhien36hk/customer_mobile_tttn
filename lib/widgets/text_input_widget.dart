import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gotta_go/constants/constant.dart';

class TextInputWidget extends StatelessWidget {
  final IconData iconName;
  final String hintText;
  final String labelText;
  final TextEditingController controller;
  final bool isPassword;
  final String? Function(String?)? validator;

  const TextInputWidget({
    super.key,
    required this.iconName,
    required this.hintText,
    required this.labelText,
    required this.controller,
    this.isPassword = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        prefixIcon: Icon(iconName),
        hintText: hintText,
        labelText: labelText,
        filled: false,
        fillColor: Colors.red[200],
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Constants.buttonColor, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 13),
      ),
      validator: validator,
    );
  }
}
