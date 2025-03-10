import 'package:flutter/material.dart';

class WarningWidget extends StatelessWidget {
  WarningWidget(
      {super.key, required this.colorInfor, required this.textWarning});

  Color colorInfor;
  String textWarning;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Icon(
        Icons.info_outline_rounded,
        size: 40,
        color: colorInfor,
      ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            textWarning,
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      contentPadding: EdgeInsets.all(20),
      actions: [
        Center(
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Ok", style: TextStyle(color: Colors.white),),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 100, vertical: 12),
              backgroundColor: Colors.green,
            ),
          ),
        )
      ],
    );
  }
}
