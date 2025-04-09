import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import '../../constants/map_key.dart';
import '../api_services/api_assistant.dart';
import '../../models/direction_detail_info.dart';

class PolylineService {
  // Lấy thông tin đường đi và thời gian từ LocationIQ API
  static Future<DirectionDetailInfo> obtainDirectionDetails(LatLng origin, LatLng destination) async {
    // Tạo api directin chuẩn locationIQ
    String url = ApiAssistant.createApiDirectionLocation(origin, destination);

    var response = await ApiAssistant.requestApi(url);
    
    if (response == "Error Occured. Failed. No Response.") {
      throw Exception("Không thể kết nối đến LocationIQ API");
    }

    // Chuyển dữ liệu sang đói tượng 
    return DirectionDetailInfo.fromJson(response);
  }

  // Lấy thông tin đường đi và thời gian
  static Future<Map<String, dynamic>> getRouteInfo(LatLng origin, LatLng destination) async {
    try {
      DirectionDetailInfo directionInfo = await obtainDirectionDetails(origin, destination);
      
      // Giải mã polyline string thành danh sách các điểm
      PolylinePoints polylinePoints = PolylinePoints();
      List<PointLatLng> decodedPolylinePoints = polylinePoints.decodePolyline(directionInfo.e_points!);
      
      // Chuyển đổi sang danh sách điểm LatLng cho Google Maps
      List<LatLng> polylineCoordinates = [];
      for (var point in decodedPolylinePoints) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
      
      return {
        'polyline': polylineCoordinates,
        'duration': directionInfo.duration_value! / 60, // Chuyển sang phút
        'distance': directionInfo.distance_value! / 1000, // Chuyển sang km
      };
    } catch (e) {
      throw Exception('Lỗi khi lấy thông tin đường đi: $e');
    }
  }
} 