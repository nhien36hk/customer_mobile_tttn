import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gotta_go/constants/key.dart';
import 'package:gotta_go/constants/vnpay_constants.dart';
import 'package:gotta_go/main.dart';
import 'package:gotta_go/models/create_order_response.dart';
import 'package:gotta_go/models/schedule_model.dart';
import 'package:gotta_go/models/seat_booking_model.dart';
import 'package:gotta_go/models/vnpay_payment_result.dart';
import 'package:gotta_go/screens/page_screens/home/booking_screens/vnpay_webview_screen.dart';
import 'package:gotta_go/services/ticket_service.dart';
import 'package:gotta_go/services/vnpay_services.dart';
import 'package:gotta_go/utils/endpoints.dart';
import 'package:gotta_go/utils/util.dart' as utils;
import 'package:http/http.dart' as http;

class BankServices {
  static Future<bool> onPaymentVNPAY(
      SeatBookingModel seatBookingModel, ScheduleModel trip) async {
    try {
      // Lấy địa chỉ IP (Trong thực tế nên lấy IP thực tế của thiết bị)
      String ipAddress = '192.168.1.1';

      // Tạo các thông tin thanh toán
      int totalAmount = (seatBookingModel.counTotalPrice + 20000) * 100; // Nhân 100 để loại bỏ phần thập phân

      String orderInfo = 'Thanh toan ve xe tuyen ${trip.startLocation} - ${trip.endLocation}';

      // Tạo URL thanh toán
      String paymentUrl = VNPayService.createPaymentUrl(
        amount: totalAmount,
        orderInfo: orderInfo,
        orderType: VNPayConstants.orderType,
        returnUrl: VNPayConstants.sandboxReturnUrl,
        ipAddress: ipAddress,
      );

      // Lưu thông tin về giao dịch vào Firebase khi bắt đầu thanh toán
      if (navigatorKey.currentContext != null) {
        final BuildContext context = navigatorKey.currentContext!;

        // Tạo Completer để xử lý kết quả callback
        final Completer<bool> completer = Completer<bool>();
        
        // Hiển thị WebView để thanh toán
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VNPayWebViewScreen(
              paymentUrl: paymentUrl,
              returnUrl: VNPayConstants.sandboxReturnUrl,
              onPaymentComplete: (VNPayPaymentResult result) async {
                // Xử lý kết quả thanh toán
                if (result.isSuccess) {
                  // Lưu vé nếu thanh toán thành công
                  await TicketServices.saveTicket(seatBookingModel, trip);
                  completer.complete(true);
                } else {
                  // Hiển thị thông báo lỗi
                  Fluttertoast.showToast(
                    msg: result.message,
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.CENTER,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                  );
                  completer.complete(false);
                }
              },
            ),
          ),
        );

        // Đợi kết quả từ callback
        return await completer.future;
      } else {
        throw Exception('Không thể truy cập context');
      }
    } catch (e) {
      print("Lỗi thanh toán: $e");
      return false;
    }
  }

  static Future<CreateOrderResponse?> onPaymentZaloPay(int price) async {
    var header = new Map<String, String>();
    header["Content-Type"] = "application/x-www-form-urlencoded";

    var body = new Map<String, String>();
    body["app_id"] = appIdZalo.toString();
    body["app_user"] = appUser;
    body["app_time"] = DateTime.now().millisecondsSinceEpoch.toString();
    body["amount"] = price.toStringAsFixed(0);
    body["app_trans_id"] = utils.getAppTransId();
    body["embed_data"] = "{}";
    body["item"] = "[]";
    body["bank_code"] = utils.getBankCode();
    body["description"] = utils.getDescription(body["app_trans_id"]!);

    var dataGetMac = sprintf("%s|%s|%s|%s|%s|%s|%s", [
      body["app_id"],
      body["app_trans_id"],
      body["app_user"],
      body["amount"],
      body["app_time"],
      body["embed_data"],
      body["item"]
    ]);
    body["mac"] = utils.getMacCreateOrder(dataGetMac);
    print("mac: ${body["mac"]}");

    // Gửi request
    var response = await http.post(
      Uri.parse(Endpoints.createOrderUrl), // Sửa lại URL đúng
      headers: header,
      body: body,
    );

    print("body_request: $body");
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print("Parsed response data: $data");
      return CreateOrderResponse.fromJson(data);
    } else {
      Fluttertoast.showToast(msg: "Error: ${response.body}");
      return null;
    }
  }

  static sprintf(String s, List<String?> list) {}
}
