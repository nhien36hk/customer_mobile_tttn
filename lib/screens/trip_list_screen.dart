import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:gotta_go/constants/constant.dart';
import 'package:gotta_go/models/schedule_model.dart';
import 'package:gotta_go/screens/seat_selection_screen.dart';
import 'package:gotta_go/screens/booking_information.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class TripListScreen extends StatefulWidget {
  TripListScreen({super.key, required this.listSchedules});

  List<ScheduleModel> listSchedules;

  @override
  State<TripListScreen> createState() => _TripListScreenState();
}

class _TripListScreenState extends State<TripListScreen> {
  // Dữ liệu giả cho danh sách chuyến xe

  @override
  void initState() {
    super.initState();
  }

  String? timeHour;
  String? timeMinute;

  String converseTime(String time) {
    DateTime timeConverse = DateTime.parse(time).toLocal();
    String timeFormat = DateFormat("HH:mm").format(timeConverse);
    return timeFormat;
  }

  void countTime(String departureTime, String arrivalTime) {
    DateTime departureTimeConverse = DateTime.parse(departureTime).toLocal();
    DateTime arrivalTimeConverse = DateTime.parse(arrivalTime).toLocal();
    Duration differenceTime =
        arrivalTimeConverse.difference(departureTimeConverse);
    timeHour = differenceTime.inHours.toString(); // Lấy số giờ
    timeMinute =
        (differenceTime.inMinutes % 60).toString(); // Lấy số phút còn lại
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEF2FD),
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Constants.backgroundColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Expanded(
                        child: Text(
                          'Hồ Chí Minh → Lâm Đồng',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.more_vert, color: Colors.white),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Icon(Icons.calendar_today, size: 20),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.chevron_left),
                              onPressed: () {},
                            ),
                            Text(
                              'Thứ sáu, 17/01/2025',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            IconButton(
                              icon: const Icon(Icons.chevron_right),
                              onPressed: () {},
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Iconsax.setting_55,
                            size: 20,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          widget.listSchedules.length == 0
              ? Expanded(
                  child: Center(
                    child: Text(
                      "Hiện không có chuyến nào trong ngày bạn chọn. Vui lòng chọn ngày khác!",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                )
              :

              // Trip List
              Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: widget.listSchedules.length,
                    itemBuilder: (context, index) {
                      ScheduleModel item = widget.listSchedules[index];
                      countTime(item.departureTime, item.arrivalTime);
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SeatSelectionScreen(
                                schedule: item,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white,
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
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 150,
                                    child: Text(
                                      item.nameCar,
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 15,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.blue[50],
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      'Còn ${item.emptySeats} chỗ trống',
                                      style: const TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Divider(
                                thickness: 0.2,
                                color: Colors.grey,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    converseTime(item.departureTime),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.circle,
                                            color: Constants.backgroundColor,
                                            size: 15,
                                          ),
                                          SizedBox(
                                            width: 45,
                                            height: 2,
                                            child: Container(
                                              color: Constants.backgroundColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 7,
                                        ),
                                        child: Text(
                                          "${timeHour}h${timeMinute}p",
                                          style: const TextStyle(
                                              color: Constants.buttonColor),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 45,
                                            height: 2,
                                            child: Container(
                                              color: Constants.backgroundColor,
                                            ),
                                          ),
                                          const Icon(
                                            Icons.circle_outlined,
                                            color: Constants.backgroundColor,
                                            size: 15,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Text(
                                    converseTime(item.arrivalTime),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    item.startLocation,
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    item.endLocation,
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Dash(
                                direction: Axis
                                    .horizontal, // Hướng của đường kẻ (ngang)
                                length: 320, // Độ dài của đường
                                dashLength: 5, // Chiều dài mỗi đoạn gạch
                                dashGap: 3, // Khoảng cách giữa các đoạn
                                dashColor: Colors.grey, // Màu của đường kẻ
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Spacer(),
                                  Text(
                                    item.price.toString(),
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Constants.backgroundColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
