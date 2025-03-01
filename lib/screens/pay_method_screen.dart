import 'package:flutter/material.dart';
import 'package:gotta_go/widgets/method_pay_widget.dart';

class PayMethodScreen extends StatefulWidget {
  const PayMethodScreen({super.key});

  @override
  State<PayMethodScreen> createState() => _PayMethodScreenState();
}

class _PayMethodScreenState extends State<PayMethodScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios,
            ),
          ),
          title: Text(
            "Phương thức thanh toán",
            style: TextStyle(fontSize: 20),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () => Navigator.pop(context,
                  {"image": "images/vnpay-logo.jpg", "method": "VNPAY"}),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.transparent
                ),
                child: MethodPayWidget(
                    urlImage: "images/vnpay-logo.jpg", textMethod: "VNPAY"),
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.pop(context,
                  {"image": "images/zalo_pa.png", "method": "ZALOPAY"}),
              child: Container(
                width: MediaQuery.of(context).size.width,
                 decoration: BoxDecoration(
                  color: Colors.transparent
                ),
                child: MethodPayWidget(
                    urlImage: "images/zalo_pa.png", textMethod: "ZALOPAY"),
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.pop(
                  context, {"image": "images/cash_icon.png", "method": "CASH"}),
              child: Container(
                width: MediaQuery.of(context).size.width,
                 decoration: BoxDecoration(
                  color: Colors.transparent
                ),
                child: MethodPayWidget(
                    urlImage: "images/cash_icon.png",
                    textMethod: "Thanh toán bằng tiền mặt"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
