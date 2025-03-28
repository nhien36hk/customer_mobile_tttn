import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gotta_go/constants/global.dart';
import 'package:gotta_go/models/route_model.dart';
import 'package:gotta_go/models/schedule_model.dart';
import 'package:gotta_go/screens/search_trip_screen.dart';
import 'package:gotta_go/services/search_history_service.dart';
import 'package:gotta_go/widgets/warning_widget.dart';
import 'package:intl/intl.dart';

class BusServices {
  static final SearchHistoryService _searchHistoryService =
      SearchHistoryService();

  static Future<void> searchTrips(String fromLocation, String toLocation,
      DateTime selectedDate, BuildContext context) async {
    if (fromLocation != null && toLocation != null && selectedDate != null) {
      // Hiển thị loading

      String selectedDateStr = DateFormat("yyyy-MM-dd").format(selectedDate!);

      // Lưu lịch sử tìm kiếm
      if (firebaseAuth.currentUser != null) {
        try {
          await _searchHistoryService.saveSearchHistory(
              fromLocation, toLocation, selectedDate);
        } catch (e) {
          print("Lỗi khi lưu lịch sử tìm kiếm: $e");
        }
      }

      QuerySnapshot querySnapshot = await firebaseFirestore
          .collection("routes")
          .where('from', isEqualTo: fromLocation)
          .where('to', isEqualTo: toLocation)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot routeDoc = querySnapshot.docs.first;
        String idRoute = routeDoc.id;
        QuerySnapshot querySchedule = await firebaseFirestore
            .collection("schedules")
            .where('routeId', isEqualTo: idRoute)
            .get();

        if (querySchedule.docs.isNotEmpty) {
          // Nếu có lịch trình tương ứng với route
          List<ScheduleModel> listSchedules = [];
          for (var scheduleDoc in querySchedule.docs) {
            // Chuyển đổi thời gian FormatDate và String giống nhau
            String departureTimeStr = scheduleDoc['departureTime'];
            DateTime departureTime = DateTime.parse(departureTimeStr).toLocal();
            //  DateTime departureTime = DateTime.parse(departureTimeStr);
            String departureFormat =
                DateFormat("yyyy-MM-dd").format(departureTime);

            print(
                "selectedDate $selectedDateStr formatDate$departureFormat lasttime$departureTimeStr");

            // Nếu thời gian lựa chọn và thời gian khởi hành cùng ngày
            // So sánh ngày đã được format để đảm bảo cùng định dạng yyyy-MM-dd
            if (selectedDateStr == departureFormat) {
              String idSeatLayout =
                  scheduleDoc['seatLayoutId']; // Lấy id SeatLayout
              String busId = scheduleDoc['busId'];
              DocumentSnapshot busDoc =
                  await firebaseFirestore.collection("buses").doc(busId).get();
              String nameCar = busDoc['busNumber'];
              DocumentSnapshot seatLayoutDoc =
                  await firebaseFirestore // Truy vấn Document SeatLayout
                      .collection("seatLayouts")
                      .doc(idSeatLayout)
                      .get();
              if (seatLayoutDoc.exists && seatLayoutDoc != null) {
                // Chuyển đổi dạng Data sang Map
                Map<String, dynamic> seatLayoutMap =
                    seatLayoutDoc.data() as Map<String, dynamic>;
                int availableSeats = await countAvailableSeats(
                    seatLayoutMap); // Đếm số ghế trống
                // Chuyển đổi thành model
                ScheduleModel itemSchedule = ScheduleModel.fromSnapshot(
                    scheduleDoc,
                    availableSeats,
                    nameCar,
                    fromLocation,
                    toLocation);
                listSchedules.add(itemSchedule); // Thêm từng model cùng ngày
              } else {
                Fluttertoast.showToast(msg: "Seat Layout Null");
              }
            } else {}
          }

          Navigator.pop(context);
          print("ALl Trip $listSchedules");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchTripScreen(
                listSchedules: listSchedules,
                fromLocation: fromLocation,
                selectedDate: selectedDate,
                toLocation: toLocation,
              ),
            ),
          );
        } else {
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (context) => WarningWidget(
                colorInfor: Colors.red, textWarning: "Không có lịch trình nào với tuyến này"),
          );
        }
      } else {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) => WarningWidget(
              colorInfor: Colors.red,
              textWarning: "Hiện tại không có chuyến nào trong ngày hôm đó"),
        );
        Fluttertoast.showToast(msg: "Không có tuyến nào như vậy cả!");
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng chọn đầy đủ thông tin'),
        ),
      );
    }
  }

  static Future<int> countAvailableSeats(
      Map<String, dynamic> seatLayout) async {
    int countSeats = 0;
    seatLayout.forEach(
      (key, value) {
        if (key == "floor1" || key == "floor2") {
          value.forEach(
            (key, value) {
              if (value['isBooked'] == false) {
                countSeats++;
              }
            },
          );
        }
      },
    );
    print("So ghe con trong" + countSeats.toString());
    return countSeats;
  }

  static Future<List<RouteModel>> popularTrip() async {
    List<RouteModel> listPopular;
    try {
      QuerySnapshot querySnapshot =
          await firebaseFirestore.collection("routes").get();
      listPopular = querySnapshot.docs
          .map((doc) => RouteModel.fromSnapshot(doc))
          .toList();
      return listPopular;
    } catch (e) {
      Fluttertoast.showToast(msg: "Lỗi lấy route $e");
    }
    return [];
  }

  static Future<void> searchTripsForState(
      String fromLocation,
      String toLocation,
      DateTime selectedDate,
      BuildContext context,
      Function(List<ScheduleModel>) onComplete) async {
    if (fromLocation != null && toLocation != null && selectedDate != null) {
      // Lưu lịch sử tìm kiếm
      if (firebaseAuth.currentUser != null) {
        try {
          await _searchHistoryService.saveSearchHistory(
              fromLocation, toLocation, selectedDate);
        } catch (e) {
          print("Lỗi khi lưu lịch sử tìm kiếm: $e");
        }
      }

      String selectedDateStr = DateFormat("yyyy-MM-dd").format(selectedDate);
      QuerySnapshot querySnapshot = await firebaseFirestore
          .collection("routes")
          .where('from', isEqualTo: fromLocation)
          .where('to', isEqualTo: toLocation)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot routeDoc = querySnapshot.docs.first;
        String idRoute = routeDoc.id;
        QuerySnapshot querySchedule = await firebaseFirestore
            .collection("schedules")
            .where('routeId', isEqualTo: idRoute)
            .get();

        if (querySchedule.docs.isNotEmpty) {
          List<ScheduleModel> listSchedules = [];
          for (var scheduleDoc in querySchedule.docs) {
            String departureTimeStr = scheduleDoc['departureTime'];
            DateTime departureTime = DateTime.parse(departureTimeStr).toLocal();
            String departureFormat =
                DateFormat("yyyy-MM-dd").format(departureTime);

            if (selectedDateStr == departureFormat) {
              String idSeatLayout = scheduleDoc['seatLayoutId'];
              String busId = scheduleDoc['busId'];
              DocumentSnapshot busDoc =
                  await firebaseFirestore.collection("buses").doc(busId).get();
              String nameCar = busDoc['busNumber'];
              DocumentSnapshot seatLayoutDoc = await firebaseFirestore
                  .collection("seatLayouts")
                  .doc(idSeatLayout)
                  .get();

              if (seatLayoutDoc.exists && seatLayoutDoc != null) {
                Map<String, dynamic> seatLayoutMap =
                    seatLayoutDoc.data() as Map<String, dynamic>;
                int availableSeats = await countAvailableSeats(seatLayoutMap);
                ScheduleModel itemSchedule = ScheduleModel.fromSnapshot(
                    scheduleDoc,
                    availableSeats,
                    nameCar,
                    fromLocation,
                    toLocation);
                listSchedules.add(itemSchedule);
              }
            }
          }
          onComplete(listSchedules);
        } else {
          onComplete([]);
        }
      } else {
        onComplete([]);
      }
    }
  }
}
