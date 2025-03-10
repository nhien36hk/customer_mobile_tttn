import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gotta_go/constants/constant.dart';
import 'package:gotta_go/constants/global.dart';
import 'package:gotta_go/models/schedule_model.dart';
import 'package:gotta_go/models/seat_booking_model.dart';
import 'package:gotta_go/screens/ticket_detail_screen.dart';
import 'package:gotta_go/screens/ticket_screen.dart';
import 'package:gotta_go/widgets/loading_widget.dart';

class BookingServices {
  static void bookingTicket(
    BuildContext context,
    ScheduleModel trip,
    SeatBookingModel seatBookingModel,
    String? methodPay,
  ) async {
    if (trip.emptySeats! > 0 && methodPay != null) {
      showDialog(
        context: context,
        builder: (context) => LoadingWidget(),
      );

      DocumentSnapshot documentSnapshot = await firebaseFirestore
          .collection("seatLayouts")
          .doc(trip.seatLayoutId)
          .get();

      String scheduleId = documentSnapshot['scheduleId'];

      Map<String, dynamic> ticketMap = {
        "routeId": trip.routeId,
        "seatLayoutId": trip.seatLayoutId,
        "scheduleId": scheduleId,
        "customerId": firebaseAuth.currentUser!.uid,
        "busId": trip.busId,
        "seatNumber": {
          "floor1": seatBookingModel.selectSeatFloor1,
          "floor2": seatBookingModel.selectSeatFloor2,
        },
        "from": trip.startLocation,
        "to": trip.endLocation,
        "price": seatBookingModel.totalPrice,
        "status": "booking",
        "departureTime": trip.departureTime,
        "arrivalTime": trip.arrivalTime,
        "bookingTime": DateTime.now()
      };

      await firebaseFirestore.collection("tickets").doc().set(ticketMap);

      Navigator.pop(context);

      Navigator.push(context, MaterialPageRoute(builder: (context) => TicketScreen()));

      Fluttertoast.showToast(msg: "Đặt vé thành công");
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Icon(
              Icons.info_outline_rounded,
              color: Colors.red,
              size: 40,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Vui lòng chọn phương thức thanh toán",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )
              ],
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "Ok",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35)),
                      backgroundColor: Constants.backgroundColor,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      );
    }
  }
}
