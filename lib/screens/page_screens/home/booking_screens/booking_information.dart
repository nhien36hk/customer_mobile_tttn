import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gotta_go/constants/constant.dart';
import 'package:gotta_go/constants/global.dart';
import 'package:gotta_go/constants/key.dart';
import 'package:gotta_go/models/create_order_response.dart';
import 'package:gotta_go/models/schedule_model.dart';
import 'package:gotta_go/models/seat_booking_model.dart';
import 'package:gotta_go/screens/page_screens/home/booking_screens/chose_pay_method_screen.dart';
import 'package:gotta_go/screens/page_screens/home/booking_screens/seat_selection_screen.dart';
import 'package:gotta_go/services/booking_services.dart';
import 'package:gotta_go/utils/endpoints.dart';
import 'package:gotta_go/widgets/loading_widget.dart';
import 'package:gotta_go/widgets/method_pay_widget.dart';
import 'package:intl/intl.dart';
import 'package:sprintf/sprintf.dart';

class BookingInformation extends StatefulWidget {
  final ScheduleModel trip;
  final SeatBookingModel seatBookingModel;

  const BookingInformation({
    super.key,
    required this.trip,
    required this.seatBookingModel,
  });

  @override
  State<BookingInformation> createState() => _BookingInformationState();
}

class _BookingInformationState extends State<BookingInformation> {
  @override
  void initState() {
    super.initState();
  }

  String? methodPay;
  String? imagePay;

  void selectMethodPay() async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChosePayMethodScreen(),
      ),
    );
    if (result != null) {
      setState(() {
        methodPay = result['method'];
        imagePay = result['image'];
      });
    }
  }

  String formatTime() {
    Intl.defaultLocale = "vi_VN";
    DateTime dateTime = DateTime.parse(widget.trip.departureTime).toLocal();
    String dateFormat = DateFormat("EEEE, dd/MM/yyyy • HH:mm").format(dateTime);
    return dateFormat;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.backgroundColor,
        title: const Text(
          'Thanh toán đơn hàng',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Route Info
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    children: [
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.location_on,
                              color: Constants.backgroundColor,
                            ),
                          ),
                          Container(
                            width: 2,
                            height: 30,
                            color: Colors.grey[300],
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.red[50],
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.location_on,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.trip.startLocation,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              widget.trip.endLocation,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Trip Info
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: Column(
                children: [
                  _buildInfoRow(Icons.access_time, 'Thời gian', formatTime()),
                  const Divider(),
                  _buildInfoRow(Icons.airline_seat_recline_normal, 'Loại ghế',
                      'Giường nằm'),
                  const Divider(),
                  _buildInfoRow(Icons.person_outline, 'Số lượng',
                      '${widget.seatBookingModel.countTotalSeats} ghế'),
                  const Divider(),
                ],
              ),
            ),
            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Chọn phương thức thanh toán",
                        style: TextStyle(fontSize: 15),
                      ),
                      TextButton(
                        onPressed: () => selectMethodPay(),
                        child: Text(
                          "Xem tất cả",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  if (imagePay != null && methodPay != null)
                    Container(
                      padding: EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 1, color: Colors.grey),
                        color: Colors.grey[200],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Image.asset(
                            imagePay!,
                            fit: BoxFit.cover,
                            width: 60,
                            height: 60,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            methodPay! == "CASH"
                                ? "Thanh toán tại nhà xe"
                                : methodPay!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Spacer(),
                          Icon(
                            Icons.check_circle_outline,
                            color: const Color.fromARGB(255, 14, 194, 20),
                          )
                        ],
                      ),
                    )
                  else
                    // Có thể để trống hoặc thêm widget khác
                    Container(), // Hoặc một widget khác nếu cần
                ],
              ),
            ),

            // Price Info
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Giá vé'),
                      Text(
                        widget.seatBookingModel.counTotalPrice.toString(),
                        style: TextStyle(
                          color: Constants.backgroundColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Phí dịch vụ'),
                      Text(
                        '20.000đ',
                        style: TextStyle(
                          color: Constants.backgroundColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Tổng cộng',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        (widget.seatBookingModel.countTotalSeats + 20000)
                            .toString(),
                        style: TextStyle(
                          fontSize: 18,
                          color: Constants.backgroundColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {
            BookingServices.bookingTicket(
              context,
              widget.trip,
              widget.seatBookingModel,
              methodPay,
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Constants.backgroundColor,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Text(
            'Đặt vé',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
