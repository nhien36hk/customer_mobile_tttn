import 'package:flutter/material.dart';

class Constants {
  // Màu chính
  static const Color buttonColor = Color(0xFF042D62);
  static const Color backgroundColor = Color(0xFFE65100);
  static const Color textButtonCOlor = Color(0xFFFFB557);
  
  // Màu bổ sung
  static const Color secondaryOrange = Color(0xFFFF9800);
  static const Color lightOrange = Color(0xFFFFB557);
  static const Color darkOrange = Color(0xFFD84315);
  
  // Gradient
  static const LinearGradient mainGradient = LinearGradient(
    colors: [backgroundColor, secondaryOrange],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient buttonGradient = LinearGradient(
    colors: [secondaryOrange, backgroundColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Hiệu ứng Shadow
  static BoxShadow mainShadow = BoxShadow(
    color: backgroundColor.withOpacity(0.3),
    blurRadius: 10,
    offset: const Offset(0, 5),
  );
  
  // Animation Duration
  static const Duration animationDuration = Duration(milliseconds: 300);
  
  // Định dạng border chính
  static BorderRadius borderRadius = BorderRadius.circular(16.0);
  static BorderRadius buttonBorderRadius = BorderRadius.circular(30.0);
}
