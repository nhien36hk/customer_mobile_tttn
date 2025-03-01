import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gotta_go/constants/constant.dart';
import 'package:gotta_go/constants/global.dart';
import 'package:gotta_go/screens/login_screen.dart';
import 'package:gotta_go/screens/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  void startTimer() {
    Timer(Duration(seconds: 3), () async {
      if(await firebaseAuth.currentUser != null) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => MainScreen()));
      } else {
        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      body: Center(
        child: Image.asset("images/logo_no_circle.png"),
      ),
    );
  }
}