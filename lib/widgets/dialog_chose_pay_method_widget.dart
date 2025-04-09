import 'package:flutter/material.dart';
import 'package:gotta_go/widgets/gradient_button.dart';
import 'package:gotta_go/widgets/modern_card.dart';

class DialogChosePayMethodWidget extends StatelessWidget {
  const DialogChosePayMethodWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      elevation: 5,
      backgroundColor: Colors.transparent,
      child: ModernCard(
        padding: EdgeInsets.zero,
        borderRadius: 25,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 24, horizontal: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.white.withOpacity(0.9)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red.withOpacity(0.1),
                ),
                child: const Icon(
                  Icons.info_outline_rounded,
                  color: Colors.red,
                  size: 40,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Vui lòng chọn phương thức thanh toán",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              GradientButton(
                text: "Đồng ý",
                onPressed: () => Navigator.pop(context),
                height: 55,
                borderRadius: 35,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
