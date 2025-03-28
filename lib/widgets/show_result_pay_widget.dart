import 'package:flutter/material.dart';

class ShowResultPayWidget extends StatelessWidget {
  ShowResultPayWidget({super.key, required this.result});

  final String result;

  @override
  Widget build(BuildContext context) {
    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: darkTheme ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Animation container for the icon
          TweenAnimationBuilder(
            duration: const Duration(milliseconds: 500),
            tween: Tween<double>(begin: 0, end: 1),
            builder: (context, double value, child) {
              return Transform.scale(
                scale: value,
                child: child,
              );
            },
            child: Icon(
              result.toLowerCase().contains("thành công") 
                  ? Icons.check_circle_outline
                  : result.toLowerCase().contains("hủy")
                      ? Icons.cancel_outlined
                      : Icons.error_outline,
              size: 70,
              color: result.toLowerCase().contains("thành công")
                  ? Colors.green
                  : result.toLowerCase().contains("hủy")
                      ? Colors.orange
                      : Colors.red,
            ),
          ),
          const SizedBox(height: 20),
          
          // Result text with animation
          TweenAnimationBuilder(
            duration: const Duration(milliseconds: 700),
            tween: Tween<double>(begin: 0, end: 1),
            builder: (context, double value, child) {
              return Opacity(
                opacity: value,
                child: child,
              );
            },
            child: Text(
              result,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: darkTheme ? Colors.white : Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          const SizedBox(height: 15),
          
          // Additional message based on result
          Text(
            result.toLowerCase().contains("thành công")
                ? "Cảm ơn bạn đã sử dụng dịch vụ!"
                : result.toLowerCase().contains("hủy")
                    ? "Giao dịch đã bị hủy"
                    : "Vui lòng thử lại sau",
            style: TextStyle(
              fontSize: 16,
              color: darkTheme ? Colors.grey[400] : Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 20),
          
          // Divider
          Container(
            height: 1,
            width: double.infinity,
            color: darkTheme ? Colors.grey[800] : Colors.grey[300],
          ),
          
          const SizedBox(height: 20),
          
          // Time stamp with icon
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.access_time,
                size: 16,
                color: darkTheme ? Colors.grey[500] : Colors.grey[700],
              ),
              const SizedBox(width: 5),
              Text(
                "${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')} ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                style: TextStyle(
                  fontSize: 14,
                  color: darkTheme ? Colors.grey[500] : Colors.grey[700],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}