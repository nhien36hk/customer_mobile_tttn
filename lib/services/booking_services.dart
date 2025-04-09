import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gotta_go/models/schedule_model.dart';
import 'package:gotta_go/models/seat_booking_model.dart';
import 'package:gotta_go/screens/layout_screen.dart';
import 'package:gotta_go/services/bank_services.dart';
import 'package:gotta_go/widgets/aleart_success_widget.dart';
import 'package:gotta_go/widgets/dialog_chose_pay_method_widget.dart';
import 'package:gotta_go/widgets/loading_widget.dart';

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

      // if (methodPay == "ZALOPAY") {
      //   CreateOrderResponse? result = await onPaymentZaloPay(totalPrice);
      //   if (result != null) {
      //     zpTransToken = result.zptranstoken!;
      //     FlutterZaloPaySdk.payOrder(zpToken: zpTransToken).then((event) {
      //       String resultMessage = "";
      //       switch (event) {
      //         case FlutterZaloPayStatus.cancelled:
      //           resultMessage = "Thanh toán bị hủy";
      //           break;
      //         case FlutterZaloPayStatus.success:
      //           resultMessage = "Thanh toán thành công";
      //           saveTicket(seatBookingModel, trip);
      //           break;
      //         case FlutterZaloPayStatus.failed:
      //           resultMessage = "Thanh toán thất bại";
      //           break;
      //         default:
      //           resultMessage = "Thanh toán thất bại";
      //           break;
      //       }

      //       if (context.mounted) {
      //         showDialog(
      //           context: context,
      //           barrierDismissible: false,
      //           builder: (BuildContext context) {
      //             return WillPopScope(
      //               onWillPop: () async => false,
      //               child: AlertDialog(
      //                 content: ShowResultPayWidget(result: resultMessage),
      //                 actions: [
      //                   Padding(
      //                     padding: const EdgeInsets.symmetric(
      //                         vertical: 10), // Padding dọc
      //                     child: Center(
      //                       child: TextButton(
      //                         style: TextButton.styleFrom(
      //                           padding: EdgeInsets.symmetric(
      //                               horizontal: 20,
      //                               vertical: 10), // Padding bên trong nút
      //                           backgroundColor:
      //                               Colors.blueAccent, // Màu nền nút (nếu cần)
      //                           foregroundColor: Colors.white, // Màu chữ nút
      //                         ),
      //                         child: Text("OK",
      //                             style: TextStyle(
      //                                 fontSize: 16,
      //                                 fontWeight: FontWeight.bold)),
      //                         onPressed: () {
      //                           Navigator.of(context).pop();
      //                           Navigator.pushReplacement(
      //                             context,
      //                             MaterialPageRoute(
      //                               builder: (context) => SplashScreen(),
      //                             ),
      //                           );
      //                         },
      //                       ),
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //             );
      //           },
      //         );
      //       }
      //     });
      //     print("zpTransToken $zpTransToken'.");
      //   }
      // }

      if (methodPay == "VNPAY") {
        // Đóng loading dialog trước khi hiển thị WebView
        Navigator.pop(context);

        // Gọi phương thức thanh toán VNPAY và đợi kết quả
        bool isSuccess = await BankServices.onPaymentVNPAY(seatBookingModel, trip);

        if(isSuccess){
            showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => AleartSuccessWidget(),
          );
        }else{
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Thanh toán thất bại")));
        }
      } else {
        // Nếu không phải VNPAY, chuyển hướng về LayoutScreen
        Navigator.pop(context); // Đóng loading dialog
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LayoutScreen()));
        Fluttertoast.showToast(msg: "Đặt vé thành công");
      }
    } else {
      // Hiển thị Dialog vui lòng chọn phương thức thanh toán
      showDialog(
        context: context,
        builder: (context) {
          return DialogChosePayMethodWidget();
        },
      );
    }
  }
}
