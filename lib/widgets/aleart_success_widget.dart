import 'package:flutter/material.dart';
import 'package:gotta_go/constants/constant.dart';
import 'package:gotta_go/screens/layout_screen.dart';

class AleartSuccessWidget extends StatefulWidget {
  const AleartSuccessWidget({super.key});

  @override
  State<AleartSuccessWidget> createState() => _AleartSuccessWidgetState();
}

class _AleartSuccessWidgetState extends State<AleartSuccessWidget> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Icon(
        Icons.verified,
        size: 35,
        color: Constants.backgroundColor,
      ),
      content: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Chúc mừng bạn đã đặt vé thành công!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
      actions: [
        Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Đóng dialog

              // Giả sử TicketListScreen nằm ở vị trí thứ 2 trong pages
              int ticketPageIndex =
                  2; // Thay đổi index này tùy theo cấu trúc pages của bạn

              // Điều hướng về màn hình chính
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LayoutScreen()),
                (route) => false,
              );

              // Chuyển đến tab Vé sử dụng GlobalKey
              Future.delayed(Duration(milliseconds: 100), () {
                LayoutScreen.switchToTab(ticketPageIndex);
              });
            },
            child: Text(
              "Xem Vé",
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
              backgroundColor: Constants.backgroundColor,
            ),
          ),
        )
      ],
    );
  }
}
