import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gotta_go/constants/global.dart';
import 'package:gotta_go/models/route_model.dart';
import 'package:gotta_go/models/schedule_model.dart';
import 'package:gotta_go/screens/search_trip_screen.dart';
import 'package:gotta_go/widgets/loading_widget.dart';

import 'bus_services.dart';

class PopularRoutesService {
  static final Random _random = Random();
  
  // Lấy danh sách lộ trình phổ biến từ collection routes
  static Future<List<Map<String, dynamic>>> getPopularRoutes() async {
    try {
      // Lấy tất cả lộ trình từ Firestore
      QuerySnapshot routesSnapshot = await firebaseFirestore
          .collection('routes')
          .get();
          
      if (routesSnapshot.docs.isEmpty) {
        print('Không có lộ trình nào trong collection routes');
        return _getFallbackRoutes();
      }

      List<DocumentSnapshot> routes = routesSnapshot.docs;
      List<Map<String, dynamic>> popularRoutes = [];
      
      // Shuffle để lấy ngẫu nhiên
      routes.shuffle(_random);
      
      // Lấy tối đa 4 lộ trình
      int limit = min(routes.length, 4);
      
      for (int i = 0; i < limit; i++) {
        DocumentSnapshot routeDoc = routes[i];
        String routeId = routeDoc.id;
        
        try {
          // Lấy thông tin lịch trình để tính toán thời gian di chuyển
          QuerySnapshot scheduleSnapshot = await firebaseFirestore
              .collection("schedules")
              .where('routeId', isEqualTo: routeId)
              .limit(1)
              .get();
          
          Map<String, dynamic> routeData = routeDoc.data() as Map<String, dynamic>;
          
          // Tính toán thời gian di chuyển
          String duration = '~4h'; // Mặc định
          String price = routeData['price'].toString();
          
          if (scheduleSnapshot.docs.isNotEmpty) {
            DocumentSnapshot scheduleDoc = scheduleSnapshot.docs.first;
            Map<String, dynamic> scheduleData = scheduleDoc.data() as Map<String, dynamic>;
            
            try {
              if (scheduleData.containsKey('departureTime') && scheduleData.containsKey('arrivalTime')) {
                Timestamp departureTime = scheduleData['departureTime'];
                Timestamp arrivalTime = scheduleData['arrivalTime'];
                
                Duration timeDiff = arrivalTime.toDate().difference(departureTime.toDate());
                int hours = timeDiff.inHours;
                int minutes = timeDiff.inMinutes % 60;
                
                duration = hours > 0
                    ? minutes > 0
                        ? '~${hours}h ${minutes}p'
                        : '~${hours}h'
                    : '~${minutes}p';
              }
              
              // Sử dụng giá từ schedule nếu có
              if (scheduleData.containsKey('price')) {
                price = scheduleData['price'].toString();
              }
            } catch (e) {
              print('Lỗi khi tính thời gian di chuyển: $e');
            }
          }
          
          // Thêm lộ trình vào danh sách
          popularRoutes.add({
            'from': routeData['from'],
            'to': routeData['to'],
            'distance': routeData['distance'],
            'duration': duration,
            'price': price,
            'image':"images/dalat.jpg",
          });
        } catch (e) {
          print('Lỗi khi xử lý lộ trình $routeId: $e');
        }
      }
      
      // Trả về danh sách lộ trình
      return popularRoutes;
    } catch (e) {
      print('Lỗi khi lấy lộ trình phổ biến: $e');
      Fluttertoast.showToast(
        msg: 'Không thể tải lộ trình phổ biến: $e',
        backgroundColor: Colors.red,
      );
      return _getFallbackRoutes();
    }
  }

  // Dữ liệu mặc định nếu không lấy được từ Firestore
  static List<Map<String, dynamic>> _getFallbackRoutes() {
    return [
      {
        'from': 'Đà Lạt',
        'to': 'TP Hồ Chí Minh',
        'distance': '310 km',
        'duration': '~6 giờ',
        'price': '150.000đ',
        'image': 'images/dalat.jpg',
      },
      {
        'from': 'Đà Lạt',
        'to': 'Đồng Nai',
        'distance': '217 km',
        'duration': '~5 giờ',
        'price': '130.000đ',
        'image': 'images/dalat.jpg',
      },
      {
        'from': 'Đà Lạt',
        'to': 'Hà Tiên',
        'distance': '614 km',
        'duration': '~12 giờ',
        'price': '250.000đ',
        'image': 'images/dalat.jpg',
      },
      {
        'from': 'Đồng Nai',
        'to': 'Hà Tiên',
        'distance': '450 km',
        'duration': '~9 giờ',
        'price': '200.000đ',
        'image': 'images/dalat.jpg',
      },
    ];
  }

  // Chuyển đến trang tìm kiếm khi chọn lộ trình phổ biến
  static void navigateToSearchTrip(
      BuildContext context, Map<String, dynamic> route) async {
    // Hiển thị loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => LoadingWidget(),
    );
    
    // Tìm kiếm chuyến đi
    BusServices.searchTrips(
        route['from'], route['to'], DateTime.now(), context);
  }
}
