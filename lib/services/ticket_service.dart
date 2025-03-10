import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
}
