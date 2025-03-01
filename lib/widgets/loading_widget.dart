import 'package:flutter/material.dart';
import 'package:gotta_go/constants/constant.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: CircularProgressIndicator(
          color: Constants.buttonColor,
          strokeWidth: 5,
          backgroundColor: Colors.grey,
        ),
      ),
    );
  }
}
  