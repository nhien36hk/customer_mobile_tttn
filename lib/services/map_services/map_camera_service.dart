import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapCameraService {
  // Tính toán LatLngBounds bao quát cả vị trí người dùng và điểm đến
  static LatLngBounds getBoundsForCameraView(LatLng userLocation, LatLng destination) {
    final southwest = LatLng(
      _min(userLocation.latitude, destination.latitude),
      _min(userLocation.longitude, destination.longitude),
    );
    
    final northeast = LatLng(
      _max(userLocation.latitude, destination.latitude),
      _max(userLocation.longitude, destination.longitude),
    );
    
    return LatLngBounds(southwest: southwest, northeast: northeast);
  }
  
  // Tạo camera update để bao quát cả hai điểm
  static CameraUpdate getCameraUpdateForBounds(LatLng userLocation, LatLng destination, [double padding = 100]) {
    final bounds = getBoundsForCameraView(userLocation, destination);
    return CameraUpdate.newLatLngBounds(bounds, padding);
  }
  
  // Tạo camera update ở giữa hai điểm
  static CameraUpdate getCameraUpdateForMidpoint(LatLng userLocation, LatLng destination, [double zoom = 13]) {
    final midLatitude = (userLocation.latitude + destination.latitude) / 2;
    final midLongitude = (userLocation.longitude + destination.longitude) / 2;
    
    return CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng(midLatitude, midLongitude),
        zoom: zoom,
      ),
    );
  }
  
  // Tính khoảng cách giữa hai điểm để có thể điều chỉnh zoom
  static double calculateDistance(LatLng userLocation, LatLng destination) {
    final double latDiff = (userLocation.latitude - destination.latitude).abs();
    final double lngDiff = (userLocation.longitude - destination.longitude).abs();
    
    // Công thức đơn giản để ước tính khoảng cách
    return latDiff + lngDiff;
  }
  
  // Hàm helper
  static double _min(double a, double b) => a < b ? a : b;
  static double _max(double a, double b) => a > b ? a : b;
} 