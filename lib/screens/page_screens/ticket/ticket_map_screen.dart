import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gotta_go/constants/constant.dart';
import 'package:gotta_go/services/map_services/location_service.dart';
import 'package:gotta_go/services/map_services/map_camera_service.dart';
import 'package:gotta_go/services/map_services/polyline_service.dart';

class TicketMapScreen extends StatefulWidget {
  final LatLng destination;

  const TicketMapScreen({
    Key? key,
    required this.destination,
  }) : super(key: key);

  @override
  State<TicketMapScreen> createState() => _TicketMapScreenState();
}

class _TicketMapScreenState extends State<TicketMapScreen> {
  GoogleMapController? _mapController;
  Set<Polyline> _polylines = {};
  LatLng? _currentLocation;
  bool _isLoading = true;
  double _estimatedDuration = 0;
  double _estimatedDistance = 0;
  
  // Service để theo dõi vị trí theo thời gian thực
  final LocationService _locationService = LocationService();
  
  // Stream subscription để theo dõi vị trí
  StreamSubscription<LatLng>? _locationSubscription;
  
  // Kiểm soát zoom
  double _currentZoom = 15.0;

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  @override
  void dispose() {
    // Hủy stream khi widget bị hủy
    _locationSubscription?.cancel();
    _locationService.stopLocationTracking();
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _initializeMap() async {
    try {
      // Lấy vị trí ban đầu
      final position = await LocationService.getCurrentLocation();
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });
      
      // Lấy thông tin đường đi
      await _getRoute();

      // Bắt đầu theo dõi vị trí
      await _locationService.startLocationTracking();      
      // Lắng nghe vị trí cập nhật
      _listenToLocationUpdates();
    } catch (e) {
      print('Lỗi khởi tạo bản đồ: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _listenToLocationUpdates() {
    _locationSubscription = _locationService.locationStream.listen((newLocation) {
      setState(() {
        _currentLocation = newLocation;
      });
      
      // Cập nhật camera để bao quát cả người dùng và điểm đến
      _updateCameraPosition();
    });
  }

  void _updateCameraPosition() {
    if (_currentLocation == null || _mapController == null) return;
    
    // Sử dụng service để tạo camera update
    final cameraUpdate = MapCameraService.getCameraUpdateForBounds(
      _currentLocation!,
      widget.destination,
      80, // Padding
    );
    
    // Cập nhật camera
    _mapController!.animateCamera(cameraUpdate).then((_) {
      // Lưu mức zoom hiện tại sau khi di chuyển camera
      _mapController!.getZoomLevel().then((zoom) {
        _currentZoom = zoom;
      });
    });
  }
  
  // Hàm phóng to
  void _zoomIn() {
    if (_mapController == null) return;
    
    _currentZoom += 1.0;
    _mapController!.animateCamera(
      CameraUpdate.zoomTo(_currentZoom),
    );
  }
  
  // Hàm thu nhỏ
  void _zoomOut() {
    if (_mapController == null) return;
    
    _currentZoom -= 1.0;
    _mapController!.animateCamera(
      CameraUpdate.zoomTo(_currentZoom),
    );
  }

  Future<void> _getRoute() async {
    if (_currentLocation == null) return;

    try {
      final routeInfo = await PolylineService.getRouteInfo(_currentLocation!, widget.destination);
      final List<LatLng> points = routeInfo['polyline'] as List<LatLng>;

      setState(() {
        _estimatedDuration = routeInfo['duration'];
        _estimatedDistance = routeInfo['distance'];

        _polylines = {
          Polyline(
            polylineId: const PolylineId('route'),
            points: points,
            color: Colors.blue,
            width: 5,
          ),
        };
      });
      
      // Cập nhật camera sau khi có đường đi
      _updateCameraPosition();
    } catch (e) {
      print('Lỗi lấy đường đi: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.backgroundColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        title: const Text(
          "Theo dõi lộ trình", 
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Constants.backgroundColor),
            ))
          : _currentLocation == null 
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_off,
                        size: 64,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Không thể lấy vị trí hiện tại',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: _initializeMap,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Constants.backgroundColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text('Thử lại'),
                      ),
                    ],
                  ),
                )
              : Stack(
                  children: [
                    GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: _currentLocation!,
                        zoom: _currentZoom,
                      ),
                      onMapCreated: (controller) {
                        _mapController = controller;
                        // Cập nhật camera ngay sau khi map được tạo
                        _updateCameraPosition();
                      },
                      onCameraMove: (CameraPosition position) {
                        _currentZoom = position.zoom;
                      },
                      polylines: _polylines,
                      markers: {
                        Marker(
                          markerId: const MarkerId('current'),
                          position: _currentLocation!,
                          icon: BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueBlue),
                          infoWindow: const InfoWindow(
                            title: 'Vị trí của bạn',
                          ),
                        ),
                        Marker(
                          markerId: const MarkerId('destination'),
                          position: widget.destination,
                          icon: BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueRed),
                          infoWindow: InfoWindow(
                            title: 'Điểm đến',
                            snippet: 'Khoảng ${_estimatedDistance.toStringAsFixed(1)} km',
                          ),
                        ),
                      },
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false, // Tắt nút vị trí mặc định, sử dụng nút tùy chỉnh
                      mapToolbarEnabled: false, // Tắt thanh công cụ mặc định
                      compassEnabled: true,
                      zoomControlsEnabled: false, // Tắt nút zoom mặc định, sử dụng nút tùy chỉnh
                    ),
                    
                    // Nút điều khiển
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Column(
                        children: [
                          // Nút trung tâm vị trí
                          Container(
                            height: 45,
                            width: 45,
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(22.5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.my_location,
                                color: Constants.backgroundColor,
                              ),
                              onPressed: _updateCameraPosition,
                            ),
                          ),
                          // Nút phóng to
                          Container(
                            height: 45,
                            width: 45,
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(22.5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.add, color: Colors.black),
                              onPressed: _zoomIn,
                            ),
                          ),
                          // Nút thu nhỏ
                          Container(
                            height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(22.5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.remove, color: Colors.black),
                              onPressed: _zoomOut,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Hiển thị thông tin thời gian và quãng đường
                    Positioned(
                      bottom: 20,
                      left: 20,
                      right: 20,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                        decoration: BoxDecoration(
                          gradient: Constants.mainGradient,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Constants.backgroundColor.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Icon(
                                    Icons.access_time,
                                    color: Constants.backgroundColor,
                                    size: 28,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Thời gian dự kiến',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white70,
                                        ),
                                      ),
                                      Text(
                                        '${_estimatedDuration.toStringAsFixed(0)} phút',
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Divider(
                                color: Colors.white.withOpacity(0.3),
                                thickness: 1,
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Icon(
                                    Icons.directions_car,
                                    color: Constants.backgroundColor,
                                    size: 28,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Khoảng cách',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white70,
                                        ),
                                      ),
                                      Text(
                                        '${_estimatedDistance.toStringAsFixed(1)} km',
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
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
                    ),
                  ],
                ),
    );
  }
}
