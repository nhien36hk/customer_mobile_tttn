import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:gotta_go/constants/constant.dart';
import 'package:gotta_go/models/schedule_model.dart';
import 'package:gotta_go/screens/date_selection_screen.dart';
import 'package:gotta_go/screens/seat_selection_screen.dart';
import 'package:gotta_go/screens/booking_information.dart';
import 'package:gotta_go/widgets/loading_widget.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:gotta_go/services/bus_services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SearchTripScreen extends StatefulWidget {
  SearchTripScreen(
      {super.key,
      required this.listSchedules,
      required this.fromLocation,
      required this.toLocation,
      required this.selectedDate});

  List<ScheduleModel> listSchedules;
  final String fromLocation;
  final String toLocation;
  final DateTime selectedDate;

  @override
  State<SearchTripScreen> createState() => _SearchTripScreenState();
}

class _SearchTripScreenState extends State<SearchTripScreen> {
  String? timeHour;
  String? timeMinute;
  DateTime? currentDate;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    currentDate = widget.selectedDate;
  }

  // Hàm chuyển ngày (lùi 1 ngày)
  void _previousDay() async {
    setState(() {
      isLoading = true;
    });
    DateTime newDate = currentDate!.subtract(const Duration(days: 1));
    await _loadTripsForNewDate(newDate);
  }

  // Hàm chuyển ngày (tiến 1 ngày)
  void _nextDay() async {
    setState(() {
      isLoading = true;
    });
    DateTime newDate = currentDate!.add(const Duration(days: 1));
    await _loadTripsForNewDate(newDate);
  }

  // Hàm tải lại danh sách chuyến xe theo ngày mới
  Future<void> _loadTripsForNewDate(DateTime newDate) async {
    try {
      await BusServices.searchTripsForState(
          widget.fromLocation, widget.toLocation, newDate, context,
          (List<ScheduleModel> newSchedules) {
        setState(() {
          widget.listSchedules = newSchedules;
          currentDate = newDate;
          isLoading = false;
        });
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: "Lỗi khi tải dữ liệu: $e");
    }
  }

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
    timeHour = differenceTime.inHours.toString();
    timeMinute = (differenceTime.inMinutes % 60).toString();
  }

  // Định dạng ngày hiển thị
  String formatSelectedDate() {
    Intl.defaultLocale = 'vi_VN';
    return DateFormat('EEEE, dd/MM/yyyy').format(currentDate!);
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
                      Expanded(
                        child: Text(
                          '${widget.fromLocation} → ${widget.toLocation}',
                          style: const TextStyle(
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
                        GestureDetector(
                          onTap: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DateSelectionScreen(
                                  fromLocation: widget.fromLocation,
                                  toLocation: widget.toLocation,
                                  isHome: false,
                                ),
                              ),
                            );
                          },
                          child: Icon(Icons.calendar_today, size: 20),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.chevron_left),
                              onPressed: isLoading ? null : _previousDay,
                            ),
                            Text(
                              formatSelectedDate(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            IconButton(
                              icon: const Icon(Icons.chevron_right),
                              onPressed: isLoading ? null : _nextDay,
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

          // Hiển thị loading khi đang tải dữ liệu
          isLoading
              ? Expanded(child: LoadingWidget())
              : widget.listSchedules.length == 0
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
                                          borderRadius:
                                              BorderRadius.circular(20),
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
                                                color:
                                                    Constants.backgroundColor,
                                                size: 15,
                                              ),
                                              SizedBox(
                                                width: 45,
                                                height: 2,
                                                child: Container(
                                                  color:
                                                      Constants.backgroundColor,
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
                                                  color:
                                                      Constants.backgroundColor,
                                                ),
                                              ),
                                              const Icon(
                                                Icons.circle_outlined,
                                                color:
                                                    Constants.backgroundColor,
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
                                        style:
                                            const TextStyle(color: Colors.grey),
                                      ),
                                      Text(
                                        item.endLocation,
                                        style:
                                            const TextStyle(color: Colors.grey),
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
