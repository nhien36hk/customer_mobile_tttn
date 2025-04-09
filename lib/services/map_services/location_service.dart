import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationService {
  // Singleton pattern
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  // Luồng vị trí
  StreamSubscription<Position>? _positionStreamSubscription;
  final _locationController = StreamController<LatLng>.broadcast();

  // Cấu hình theo dõi vị trí
  final LocationSettings _locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 10, // Cập nhật khi di chuyển ít nhất 10 mét
  );

  // Lấy stream vị trí
  Stream<LatLng> get locationStream => _locationController.stream;

    // Lấy vị trí hiện tại của người dùng
  static Future<Position> getCurrentLocation() async {
    // Kiểm tra quyền truy cập vị trí 
    await checkPermissionLocation();

    return await Geolocator.getCurrentPosition();
  }

  // Bắt đầu theo dõi vị trí
  Future<void> startLocationTracking() async {
    // Kiểm tra quyền truy cập vị trí 
    await checkPermissionLocation();

    // Theo dõi vị trí liên tục
    _positionStreamSubscription =
        Geolocator.getPositionStream(locationSettings: _locationSettings)
            .listen((Position position) {
      _locationController.add(LatLng(position.latitude, position.longitude));
    });
  }

  // Kiểm tra quyền truy cập vị trí
  static Future<void> checkPermissionLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Kiểm tra GPS được bật chưa
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Dịch vụ vị trí bị tắt.');
    }

    // Kiểm tra quyền truy cập vị trí của ứng dụng
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Quyền truy cập vị trí bị từ chối');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Quyền truy cập vị trí bị từ chối vĩnh viễn');
    }
  }

  // Dừng theo dõi vị trí
  void stopLocationTracking() {
    _positionStreamSubscription?.cancel();
  }

  // Đóng tất cả stream khi không cần thiết
  void dispose() {
    stopLocationTracking();
    _locationController.close();
  }
}
