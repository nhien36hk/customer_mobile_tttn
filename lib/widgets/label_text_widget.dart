import 'package:flutter/material.dart';

class LabelTextWidget extends StatelessWidget {
  LabelTextWidget(
      {super.key,
      required this.hintText,
      required this.iconLabel,
      required this.labelText,
      this.textController});

  String hintText;
  Icon iconLabel;
  String labelText;
  TextEditingController? textController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(labelText),
        SizedBox(
          height: 5,
        ),
        TextFormField(
          controller: textController,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey),
            prefixIcon: iconLabel,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(width: 1, color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(width: 1, color: Colors.black),
            ),
          ),
        )
      ],
    );
  }
}
