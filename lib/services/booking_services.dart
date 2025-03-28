import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zalopay_sdk/flutter_zalopay_sdk.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gotta_go/constants/constant.dart';
import 'package:gotta_go/constants/global.dart';
import 'package:gotta_go/constants/key.dart';
import 'package:gotta_go/models/create_order_response.dart';
import 'package:gotta_go/models/schedule_model.dart';
import 'package:gotta_go/models/seat_booking_model.dart';
import 'package:gotta_go/screens/home_screen.dart';
import 'package:gotta_go/screens/layout_screen.dart';
import 'package:gotta_go/screens/splash_screen.dart';
import 'package:gotta_go/screens/ticket_detail_screen.dart';
import 'package:gotta_go/screens/ticket_list_screen.dart';
import 'package:gotta_go/utils/endpoints.dart';
import 'package:gotta_go/widgets/gradient_background.dart';
import 'package:gotta_go/widgets/gradient_button.dart';
import 'package:gotta_go/widgets/loading_widget.dart';
import 'package:gotta_go/widgets/modern_card.dart';
import 'package:gotta_go/widgets/show_result_pay_widget.dart';
import 'package:gotta_go/widgets/warning_widget.dart';
import 'package:vnpay_flutter/vnpay_flutter.dart';
import 'package:gotta_go/utils/util.dart' as utils;
import 'package:http/http.dart' as http;
import 'package:gotta_go/services/vnpay_services.dart';
import 'package:gotta_go/screens/vnpay_webview_screen.dart';
import 'package:gotta_go/models/vnpay_payment_result.dart';
import 'package:gotta_go/main.dart'; // Import để sử dụng navigatorKey
import 'package:gotta_go/constants/vnpay_constants.dart';

class BookingServices {
  static void bookingTicket(
    BuildContext context,
    ScheduleModel trip,
    SeatBookingModel seatBookingModel,
    String? methodPay,
  ) async {
    var zpTransToken = "";
    int totalPrice = seatBookingModel.counTotalPrice + 20000;
    if (trip.emptySeats! > 0 && methodPay != null) {
      showDialog(
        context: context,
        builder: (context) => LoadingWidget(),
      );

      if (methodPay == "ZALOPAY") {
        CreateOrderResponse? result = await onPaymentZaloPay(totalPrice);
        if (result != null) {
          zpTransToken = result.zptranstoken!;
          FlutterZaloPaySdk.payOrder(zpToken: zpTransToken).then((event) {
            String resultMessage = "";
            switch (event) {
              case FlutterZaloPayStatus.cancelled:
                resultMessage = "Thanh toán bị hủy";
                break;
              case FlutterZaloPayStatus.success:
                resultMessage = "Thanh toán thành công";
                saveTicket(seatBookingModel, trip);
                break;
              case FlutterZaloPayStatus.failed:
                resultMessage = "Thanh toán thất bại";
                break;
              default:
                resultMessage = "Thanh toán thất bại";
                break;
            }

            if (context.mounted) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return WillPopScope(
                    onWillPop: () async => false,
                    child: AlertDialog(
                      content: ShowResultPayWidget(result: resultMessage),
                      actions: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10), // Padding dọc
                          child: Center(
                            child: TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10), // Padding bên trong nút
                                backgroundColor:
                                    Colors.blueAccent, // Màu nền nút (nếu cần)
                                foregroundColor: Colors.white, // Màu chữ nút
                              ),
                              child: Text("OK",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SplashScreen(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          });
          print("zpTransToken $zpTransToken'.");
        }
      }

      if (methodPay == "VNPAY") {
        // Đóng loading dialog trước khi hiển thị WebView
        Navigator.pop(context);

        // Gọi phương thức thanh toán VNPAY và đợi kết quả
        await onPaymentVNPAY(seatBookingModel, trip);

        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => AlertDialog(
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
                    int ticketPageIndex = 2; // Thay đổi index này tùy theo cấu trúc pages của bạn
                    
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
          ),
        );
      } else {
        // Nếu không phải VNPAY, chuyển hướng về LayoutScreen
        Navigator.pop(context); // Đóng loading dialog
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LayoutScreen()));
        Fluttertoast.showToast(msg: "Đặt vé thành công");
      }
    } else {
      showDialog(
        context: context,
        builder: (context) {
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
        },
      );
    }
  }

  static Future<void> saveTicket(
      SeatBookingModel seatBookingModel, ScheduleModel trip) async {
    DocumentSnapshot documentSnapshot = await firebaseFirestore
        .collection("seatLayouts")
        .doc(trip.seatLayoutId)
        .get();

    String scheduleId = trip.scheduleId;

    List<String> seatNumber = [
      ...seatBookingModel.selectSeatFloor1,
      ...seatBookingModel.selectSeatFloor2
    ];

    Map<String, dynamic> ticketMap = {
      "routeId": trip.routeId,
      "seatLayoutId": trip.seatLayoutId,
      "scheduleId": scheduleId,
      "customerId": firebaseAuth.currentUser!.uid,
      "busId": trip.busId,
      "seatNumber": seatNumber,
      "from": trip.startLocation,
      "to": trip.endLocation,
      "price": seatBookingModel.totalPrice,
      "status": "booking",
      "departureTime": trip.departureTime,
      "arrivalTime": trip.arrivalTime,
      "bookingTime": DateTime.now().toString(),
    };

    await firebaseFirestore.collection("tickets").doc().set(ticketMap);
    DocumentSnapshot docSeatLayout = await firebaseFirestore
        .collection("seatLayouts")
        .doc(trip.seatLayoutId)
        .get();

    Map<String, dynamic> updateFloor1 = docSeatLayout['floor1'] ?? {};
    Map<String, dynamic> updateFloor2 = docSeatLayout['floor2'] ?? {};

    // Cập nhật status ghế tầng 1
    if (seatBookingModel.selectSeatFloor1.isNotEmpty) {
      seatBookingModel.selectSeatFloor1.forEach((seat) {
        updateFloor1[seat] = {
          "bookedBy": "Nhien dep trai vcl",
          "customerInfo": "120831290",
          "isBooked": true,
        };
      });

      await firebaseFirestore
          .collection("seatLayouts")
          .doc(trip.seatLayoutId)
          .update({
        "floor1": updateFloor1,
      });
    }

    // Cập nhật status ghế tầng 2
    if (seatBookingModel.selectSeatFloor2.isNotEmpty) {
      seatBookingModel.selectSeatFloor2.forEach((seat) {
        updateFloor2[seat] = {
          "bookedBy": "Nhien dep trai vcl",
          "customerInfo": "019391283",
          "isBooked": true,
        };
      });

      await firebaseFirestore
          .collection("seatLayouts")
          .doc(trip.seatLayoutId)
          .update({
        "floor2": updateFloor2,
      });
    }
  }

  static Future<void> onPaymentVNPAY(
      SeatBookingModel seatBookingModel, ScheduleModel trip) async {
    try {
      // Lấy địa chỉ IP (Trong thực tế nên lấy IP thực tế của thiết bị)
      String ipAddress = '192.168.1.1';

      // Tạo các thông tin thanh toán
      int totalAmount = (seatBookingModel.counTotalPrice + 20000) *
          100; // Nhân 100 để loại bỏ phần thập phân
      String orderInfo =
          'Thanh toan ve xe tuyen ${trip.startLocation} - ${trip.endLocation}';

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
                  await saveTicket(seatBookingModel, trip);
                } else {
                  // Hiển thị thông báo lỗi
                  Fluttertoast.showToast(
                    msg: result.message,
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.CENTER,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                  );
                }
              },
            ),
          ),
        );
      } else {
        throw Exception('Không thể truy cập context');
      }
    } catch (e) {
      print('Lỗi khi xử lý thanh toán VNPAY: $e');
      if (navigatorKey.currentContext != null) {
        Fluttertoast.showToast(
          msg: "Có lỗi xảy ra khi xử lý thanh toán",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
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
