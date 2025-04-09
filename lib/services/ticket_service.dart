import 'dart:io';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gotta_go/constants/global.dart';
import 'package:gotta_go/models/schedule_model.dart';
import 'package:gotta_go/models/seat_booking_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TicketServices {
  // Hàm tải vé
  static Future<void> downloadTicket(GlobalKey ticketKey) async {
    try {
      if (Platform.isAndroid) {
        PermissionStatus status = await Permission.photos.status;
        if (!status.isGranted) {
          status = await Permission.photos.request();
          if (status.isPermanentlyDenied) {
            await openAppSettings();
            return;
          }
          if (!status.isGranted) {
            print("Quyền truy cập ảnh bị từ chối. Không thể tải vé.");
            return;
          }
        }
      }

// Đến đây tức là quyền đã được cấp -> tiến hành tải vé

      // Chụp ảnh widget vé
      final boundary =
          ticketKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final bytes = byteData?.buffer.asUint8List();

      if (bytes == null) throw Exception('Không thể tạo ảnh vé');

      // Lưu file vào thư mục Downloads
      Directory? directory;
      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download');
        // Tạo thư mục nếu chưa tồn tại
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      if (directory == null) throw Exception('Không thể truy cập bộ nhớ');

      final fileName = 'ticket_${DateTime.now().millisecondsSinceEpoch}.png';
      final filePath = '${directory.path}/$fileName';
      final file = File(filePath);
      await file.writeAsBytes(bytes);

      Fluttertoast.showToast(
        msg: "Đã lưu vé thành công vào thư mục Downloads",
        toastLength: Toast.LENGTH_LONG,
      );
    } catch (e) {
      throw Exception('Lỗi khi tải vé: $e');
    }
  }

  // Hàm chia sẻ vé
  static Future<void> shareTicket(GlobalKey ticketKey) async {
    try {
      // Chụp ảnh widget vé
      final boundary =
          ticketKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final bytes = byteData?.buffer.asUint8List();

      if (bytes == null) throw Exception('Không thể tạo ảnh vé');

      // Lưu file tạm thời
      final directory = await getTemporaryDirectory();
      final imagePath =
          '${directory.path}/share_ticket_${DateTime.now().millisecondsSinceEpoch}.png';
      final imageFile = File(imagePath);
      await imageFile.writeAsBytes(bytes);

      // Chia sẻ file
      await Share.shareXFiles(
        [XFile(imagePath)],
        text: 'Vé xe của tôi',
      );
    } catch (e) {
      throw Exception('Lỗi khi chia sẻ vé: $e');
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
}
